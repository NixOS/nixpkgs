#!/usr/bin/env nix-shell
#! nix-shell -i bash -p qemu ec2_ami_tools jq ec2_api_tools awscli

# To start with do: nix-shell -p awscli --run "aws configure"

set -e
set -o pipefail

version=$(nix-instantiate --eval --strict '<nixpkgs>' -A lib.nixpkgsVersion | sed s/'"'//g)
major=${version:0:5}
echo "NixOS version is $version ($major)"

stateDir=/var/tmp/ec2-image-$version
echo "keeping state in $stateDir"
mkdir -p $stateDir

rm -f ec2-amis.nix

types="hvm"
stores="ebs"
regions="eu-west-1 eu-west-2 eu-west-3 eu-central-1 us-east-1 us-east-2 us-west-1 us-west-2 ca-central-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 ap-northeast-2 sa-east-1 ap-south-1"

for type in $types; do
    link=$stateDir/$type
    imageFile=$link/nixos.qcow2
    system=x86_64-linux
    arch=x86_64

    # Build the image.
    if ! [ -L $link ]; then
        if [ $type = pv ]; then hvmFlag=false; else hvmFlag=true; fi

        echo "building image type '$type'..."
        nix-build -o $link \
            '<nixpkgs/nixos>' \
            -A config.system.build.amazonImage \
            --arg configuration "{ imports = [ <nixpkgs/nixos/maintainers/scripts/ec2/amazon-image.nix> ]; ec2.hvm = $hvmFlag; }"
    fi

    for store in $stores; do

        bucket=nixos-amis
        bucketDir="$version-$type-$store"

        prevAmi=
        prevRegion=

        for region in $regions; do

            name=nixos-$version-$arch-$type-$store
            description="NixOS $system $version ($type-$store)"

            amiFile=$stateDir/$region.$type.$store.ami-id

            if ! [ -e $amiFile ]; then

                echo "doing $name in $region..."

                if [ -n "$prevAmi" ]; then
                    ami=$(aws ec2 copy-image \
                        --region "$region" \
                        --source-region "$prevRegion" --source-image-id "$prevAmi" \
                        --name "$name" --description "$description" | jq -r '.ImageId')
                    if [ "$ami" = null ]; then break; fi
                else

                    if [ $store = s3 ]; then

                        # Bundle the image.
                        imageDir=$stateDir/$type-bundled

                        # Convert the image to raw format.
                        rawFile=$stateDir/$type.raw
                        if ! [ -e $rawFile ]; then
                            qemu-img convert -f qcow2 -O raw $imageFile $rawFile.tmp
                            mv $rawFile.tmp $rawFile
                        fi

                        if ! [ -d $imageDir ]; then
                            rm -rf $imageDir.tmp
                            mkdir -p $imageDir.tmp
                            ec2-bundle-image \
                                -d $imageDir.tmp \
                                -i $rawFile --arch $arch \
                                --user "$AWS_ACCOUNT" -c "$EC2_CERT" -k "$EC2_PRIVATE_KEY"
                            mv $imageDir.tmp $imageDir
                        fi

                        # Upload the bundle to S3.
                        if ! [ -e $imageDir/uploaded ]; then
                            echo "uploading bundle to S3..."
                            ec2-upload-bundle \
                                -m $imageDir/$type.raw.manifest.xml \
                                -b "$bucket/$bucketDir" \
                                -a "$AWS_ACCESS_KEY_ID" -s "$AWS_SECRET_ACCESS_KEY" \
                                --location EU
                            touch $imageDir/uploaded
                        fi

                        extraFlags="--image-location $bucket/$bucketDir/$type.raw.manifest.xml"

                    else

                        # Convert the image to vhd format so we don't have
                        # to upload a huge raw image.
                        vhdFile=$stateDir/$type.vhd
                        if ! [ -e $vhdFile ]; then
                            qemu-img convert -f qcow2 -O vpc $imageFile $vhdFile.tmp
                            mv $vhdFile.tmp $vhdFile
                        fi

                        vhdFileLogicalBytes="$(qemu-img info "$vhdFile" | grep ^virtual\ size: | cut -f 2 -d \(  | cut -f 1 -d \ )"
                        vhdFileLogicalGigaBytes=$(((vhdFileLogicalBytes-1)/1024/1024/1024+1)) # Round to the next GB

                        echo "Disk size is $vhdFileLogicalBytes bytes. Will be registered as $vhdFileLogicalGigaBytes GB."

                        taskId=$(cat $stateDir/$region.$type.task-id 2> /dev/null || true)
                        volId=$(cat $stateDir/$region.$type.vol-id 2> /dev/null || true)
                        snapId=$(cat $stateDir/$region.$type.snap-id 2> /dev/null || true)

                        # Import the VHD file.
                        if [ -z "$snapId" -a -z "$volId" -a -z "$taskId" ]; then
                            echo "importing $vhdFile..."
                            taskId=$(ec2-import-volume $vhdFile --no-upload -f vhd \
                                -O "$AWS_ACCESS_KEY_ID" -W "$AWS_SECRET_ACCESS_KEY" \
                                -o "$AWS_ACCESS_KEY_ID" -w "$AWS_SECRET_ACCESS_KEY" \
                                --region "$region" -z "${region}a" \
                                --bucket "$bucket" --prefix "$bucketDir/" \
                                | tee /dev/stderr \
                                | sed 's/.*\(import-vol-[0-9a-z]\+\).*/\1/ ; t ; d')
                            echo -n "$taskId" > $stateDir/$region.$type.task-id
                        fi

                        if [ -z "$snapId" -a -z "$volId" ]; then
                            ec2-resume-import  $vhdFile -t "$taskId" --region "$region" \
                                -O "$AWS_ACCESS_KEY_ID" -W "$AWS_SECRET_ACCESS_KEY" \
                                -o "$AWS_ACCESS_KEY_ID" -w "$AWS_SECRET_ACCESS_KEY"
                        fi

                        # Wait for the volume creation to finish.
                        if [ -z "$snapId" -a -z "$volId" ]; then
                            echo "waiting for import to finish..."
                            while true; do
                                volId=$(aws ec2 describe-conversion-tasks --conversion-task-ids "$taskId" --region "$region" | jq -r .ConversionTasks[0].ImportVolume.Volume.Id)
                                if [ "$volId" != null ]; then break; fi
                                sleep 10
                            done

                            echo -n "$volId" > $stateDir/$region.$type.vol-id
                        fi

                        # Delete the import task.
                        if [ -n "$volId" -a -n "$taskId" ]; then
                            echo "removing import task..."
                            ec2-delete-disk-image -t "$taskId" --region "$region" \
                                -O "$AWS_ACCESS_KEY_ID" -W "$AWS_SECRET_ACCESS_KEY" \
                                -o "$AWS_ACCESS_KEY_ID" -w "$AWS_SECRET_ACCESS_KEY" || true
                            rm -f $stateDir/$region.$type.task-id
                        fi

                        # Create a snapshot.
                        if [ -z "$snapId" ]; then
                            echo "creating snapshot..."
                            snapId=$(aws ec2 create-snapshot --volume-id "$volId" --region "$region" --description "$description" | jq -r .SnapshotId)
                            if [ "$snapId" = null ]; then exit 1; fi
                            echo -n "$snapId" > $stateDir/$region.$type.snap-id
                        fi

                        # Wait for the snapshot to finish.
                        echo "waiting for snapshot to finish..."
                        while true; do
                            status=$(aws ec2 describe-snapshots --snapshot-ids "$snapId" --region "$region" | jq -r .Snapshots[0].State)
                            if [ "$status" = completed ]; then break; fi
                            sleep 10
                        done

                        # Delete the volume.
                        if [ -n "$volId" ]; then
                            echo "deleting volume..."
                            aws ec2 delete-volume --volume-id "$volId" --region "$region" || true
                            rm -f $stateDir/$region.$type.vol-id
                        fi

                        blockDeviceMappings="DeviceName=/dev/sda1,Ebs={SnapshotId=$snapId,VolumeSize=$vhdFileLogicalGigaBytes,DeleteOnTermination=true,VolumeType=gp2}"
                        extraFlags=""

                        if [ $type = pv ]; then
                            extraFlags+=" --root-device-name /dev/sda1"
                        else
                            extraFlags+=" --root-device-name /dev/sda1"
                            extraFlags+=" --sriov-net-support simple"
                            extraFlags+=" --ena-support"
                        fi

                        blockDeviceMappings+=" DeviceName=/dev/sdb,VirtualName=ephemeral0"
                        blockDeviceMappings+=" DeviceName=/dev/sdc,VirtualName=ephemeral1"
                        blockDeviceMappings+=" DeviceName=/dev/sdd,VirtualName=ephemeral2"
                        blockDeviceMappings+=" DeviceName=/dev/sde,VirtualName=ephemeral3"
                    fi

                    if [ $type = hvm ]; then
                        extraFlags+=" --sriov-net-support simple"
                        extraFlags+=" --ena-support"
                    fi

                    # Register the AMI.
                    if [ $type = pv ]; then
                        kernel=$(aws ec2 describe-images --owner amazon --filters "Name=name,Values=pv-grub-hd0_1.05-$arch.gz" | jq -r .Images[0].ImageId)
                        if [ "$kernel" = null ]; then break; fi
                        echo "using PV-GRUB kernel $kernel"
                        extraFlags+=" --virtualization-type paravirtual --kernel $kernel"
                    else
                        extraFlags+=" --virtualization-type hvm"
                    fi

                    ami=$(aws ec2 register-image \
                        --name "$name" \
                        --description "$description" \
                        --region "$region" \
                        --architecture "$arch" \
                        --block-device-mappings $blockDeviceMappings \
                        $extraFlags | jq -r .ImageId)
                    if [ "$ami" = null ]; then break; fi
                fi

                echo -n "$ami" > $amiFile
                echo "created AMI $ami of type '$type' in $region..."

            else
                ami=$(cat $amiFile)
            fi

            echo "region = $region, type = $type, store = $store, ami = $ami"

            if [ -z "$prevAmi" ]; then
                prevAmi="$ami"
                prevRegion="$region"
            fi
        done

    done

done

for type in $types; do
    link=$stateDir/$type
    system=x86_64-linux
    arch=x86_64

    for store in $stores; do

        for region in $regions; do

            name=nixos-$version-$arch-$type-$store
            amiFile=$stateDir/$region.$type.$store.ami-id
            ami=$(cat $amiFile)

            echo "region = $region, type = $type, store = $store, ami = $ami"

            echo -n "waiting for AMI..."
            while true; do
                status=$(aws ec2 describe-images --image-ids "$ami" --region "$region" | jq -r .Images[0].State)
                if [ "$status" = available ]; then break; fi
                sleep 10
                echo -n '.'
            done
            echo

            # Make the image public.
            aws ec2 modify-image-attribute \
                --image-id "$ami" --region "$region" --launch-permission 'Add={Group=all}'

            echo "  \"$major\".$region.$type-$store = \"$ami\";" >> ec2-amis.nix
        done

    done

done
