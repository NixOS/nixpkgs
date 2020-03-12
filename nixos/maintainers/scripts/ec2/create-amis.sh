#!/usr/bin/env nix-shell
#!nix-shell -p awscli -p jq -p qemu -i bash

# Uploads and registers NixOS images built from the
# <nixos/release.nix> amazonImage attribute. Images are uploaded and
# registered via a home region, and then copied to other regions.

# The home region requires an s3 bucket, and a "vmimport" IAM role
# with access to the S3 bucket.  Configuration of the vmimport role is
# documented in
# https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html

# set -x
set -euo pipefail

# configuration
state_dir=$HOME/amis/ec2-images
home_region=eu-west-1
bucket=nixos-amis

regions=(eu-west-1 eu-west-2 eu-west-3 eu-central-1 eu-north-1
         us-east-1 us-east-2 us-west-1 us-west-2
         ca-central-1
         ap-southeast-1 ap-southeast-2 ap-northeast-1 ap-northeast-2
         ap-south-1 ap-east-1
         sa-east-1)

log() {
    echo "$@" >&2
}

if [ -z "$1" ]; then
    log "Usage: ./upload-amazon-image.sh IMAGE_OUTPUT"
    exit 1
fi

# result of the amazon-image from nixos/release.nix
store_path=$1

if [ ! -e "$store_path" ]; then
    log "Store path: $store_path does not exist, fetching..."
    nix-store --realise "$store_path"
fi

if [ ! -d "$store_path" ]; then
    log "store_path: $store_path is not a directory. aborting"
    exit 1
fi

read_image_info() {
    if [ ! -e "$store_path/nix-support/image-info.json" ]; then
        log "Image missing metadata"
        exit 1
    fi
    jq -r "$1" "$store_path/nix-support/image-info.json"
}

# We handle a single image per invocation, store all attributes in
# globals for convenience.
image_label=$(read_image_info .label)
image_system=$(read_image_info .system)
image_file=$(read_image_info .file)
image_logical_bytes=$(read_image_info .logical_bytes)

# Derived attributes

image_logical_gigabytes=$((($image_logical_bytes-1)/1024/1024/1024+1)) # Round to the next GB

case "$image_system" in
    aarch64-linux)
        amazon_arch=arm64
        ;;
    x86_64-linux)
        amazon_arch=x86_64
        ;;
    *)
        log "Unknown system: $image_system"
        exit 1
esac

image_name="NixOS-${image_label}-${image_system}"
image_description="NixOS ${image_label} ${image_system}"

log "Image Details:"
log " Name: $image_name"
log " Description: $image_description"
log " Size (gigabytes): $image_logical_gigabytes"
log " System: $image_system"
log " Amazon Arch: $amazon_arch"

read_state() {
    local state_key=$1
    local type=$2

    cat "$state_dir/$state_key.$type" 2>/dev/null || true
}

write_state() {
    local state_key=$1
    local type=$2
    local val=$3

    mkdir -p $state_dir
    echo "$val" > "$state_dir/$state_key.$type"
}

wait_for_import() {
    local region=$1
    local task_id=$2
    local state snapshot_id
    log "Waiting for import task $task_id to be completed"
    while true; do
        read state progress snapshot_id < <(
            aws ec2 describe-import-snapshot-tasks --region $region --import-task-ids "$task_id" | \
                jq -r '.ImportSnapshotTasks[].SnapshotTaskDetail | "\(.Status) \(.Progress) \(.SnapshotId)"'
        )
        log " ... state=$state progress=$progress snapshot_id=$snapshot_id"
        case "$state" in
            active)
                sleep 10
                ;;
            completed)
                echo "$snapshot_id"
                return
                ;;
            *)
                log "Unexpected snapshot import state: '${state}'"
                exit 1
                ;;
        esac
    done
}

wait_for_image() {
    local region=$1
    local ami_id=$2
    local state
    log "Waiting for image $ami_id to be available"

    while true; do
        read state < <(
            aws ec2 describe-images --image-ids "$ami_id" --region $region | \
                jq -r ".Images[].State"
        )
        log " ... state=$state"
        case "$state" in
            pending)
                sleep 10
                ;;
            available)
                return
                ;;
            *)
                log "Unexpected AMI state: '${state}'"
                exit 1
                ;;
        esac
    done
}


make_image_public() {
    local region=$1
    local ami_id=$2

    wait_for_image $region "$ami_id"

    log "Making image $ami_id public"

    aws ec2 modify-image-attribute \
        --image-id "$ami_id" --region "$region" --launch-permission 'Add={Group=all}' >&2
}

upload_image() {
    local region=$1

    local aws_path=${image_file#/}

    local state_key="$region.$image_label.$image_system"
    local task_id=$(read_state "$state_key" task_id)
    local snapshot_id=$(read_state "$state_key" snapshot_id)
    local ami_id=$(read_state "$state_key" ami_id)

    if [ -z "$task_id" ]; then
        log "Checking for image on S3"
        if ! aws s3 ls --region "$region" "s3://${bucket}/${aws_path}" >&2; then
            log "Image missing from aws, uploading"
            aws s3 cp --region $region "$image_file" "s3://${bucket}/${aws_path}" >&2
        fi

        log "Importing image from S3 path s3://$bucket/$aws_path"

        task_id=$(aws ec2 import-snapshot --disk-container "{
          \"Description\": \"nixos-image-${image_label}-${image_system}\",
          \"Format\": \"vhd\",
          \"UserBucket\": {
              \"S3Bucket\": \"$bucket\",
              \"S3Key\": \"$aws_path\"
          }
        }" --region $region | jq -r '.ImportTaskId')

        write_state "$state_key" task_id "$task_id"
    fi

    if [ -z "$snapshot_id" ]; then
        snapshot_id=$(wait_for_import "$region" "$task_id")
        write_state "$state_key" snapshot_id "$snapshot_id"
    fi

    if [ -z "$ami_id" ]; then
        log "Registering snapshot $snapshot_id as AMI"

        local block_device_mappings=(
            "DeviceName=/dev/sda1,Ebs={SnapshotId=$snapshot_id,VolumeSize=$image_logical_gigabytes,DeleteOnTermination=true,VolumeType=gp2}"
        )

        local extra_flags=(
            --root-device-name /dev/sda1
            --sriov-net-support simple
            --ena-support
            --virtualization-type hvm
        )

        block_device_mappings+=(DeviceName=/dev/sdb,VirtualName=ephemeral0)
        block_device_mappings+=(DeviceName=/dev/sdc,VirtualName=ephemeral1)
        block_device_mappings+=(DeviceName=/dev/sdd,VirtualName=ephemeral2)
        block_device_mappings+=(DeviceName=/dev/sde,VirtualName=ephemeral3)

        ami_id=$(
            aws ec2 register-image \
                --name "$image_name" \
                --description "$image_description" \
                --region $region \
                --architecture $amazon_arch \
                --block-device-mappings "${block_device_mappings[@]}" \
                "${extra_flags[@]}" \
                | jq -r '.ImageId'
              )

        write_state "$state_key" ami_id "$ami_id"
    fi

    make_image_public $region "$ami_id"

    echo "$ami_id"
}

copy_to_region() {
    local region=$1
    local from_region=$2
    local from_ami_id=$3

    state_key="$region.$image_label.$image_system"
    ami_id=$(read_state "$state_key" ami_id)

    if [ -z "$ami_id" ]; then
        log "Copying $from_ami_id to $region"
        ami_id=$(
            aws ec2 copy-image \
                --region "$region" \
                --source-region "$from_region" \
                --source-image-id "$from_ami_id" \
                --name "$image_name" \
                --description "$image_description" \
                | jq -r '.ImageId'
              )

        write_state "$state_key" ami_id "$ami_id"
    fi

    make_image_public $region "$ami_id"

    echo "$ami_id"
}

upload_all() {
    home_image_id=$(upload_image "$home_region")
    jq -n \
       --arg key "$home_region.$image_system" \
       --arg value "$home_image_id" \
       '$ARGS.named'

    for region in "${regions[@]}"; do
        if [ "$region" = "$home_region" ]; then
            continue
        fi
        copied_image_id=$(copy_to_region "$region" "$home_region" "$home_image_id")

        jq -n \
           --arg key "$region.$image_system" \
           --arg value "$copied_image_id" \
           '$ARGS.named'
    done
}

upload_all | jq --slurp from_entries
