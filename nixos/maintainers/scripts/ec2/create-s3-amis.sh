#! /bin/sh -e

export NIXOS_CONFIG=$(dirname $(readlink -f $0))/amazon-base-config.nix

version=$(nix-instantiate --eval-only '<nixpkgs/nixos>' -A config.system.nixosVersion | sed s/'"'//g)
echo "NixOS version is $version"

buildAndUploadFor() {
    system="$1"
    arch="$2"

    echo "building $system image..."
    nix-build '<nixpkgs/nixos>' \
        -A config.system.build.amazonImage --argstr system "$system" -o ec2-ami

    ec2-bundle-image -i ./ec2-ami/nixos.img --user "$AWS_ACCOUNT" --arch "$arch" \
        -c "$EC2_CERT" -k "$EC2_PRIVATE_KEY"

    for region in eu-west-1; do
        echo "uploading $system image for $region..."

        name=nixos-$version-$arch-s3
        bucket="$(echo $name-$region | tr '[A-Z]_' '[a-z]-')"

        if [ "$region" = eu-west-1 ]; then s3location=EU;
        elif [ "$region" = us-east-1 ]; then s3location=US;
        else s3location="$region"
        fi

        ec2-upload-bundle -b "$bucket" -m /tmp/nixos.img.manifest.xml \
            -a "$EC2_ACCESS_KEY" -s "$EC2_SECRET_KEY" --location "$s3location" \
            --url http://s3.amazonaws.com

        kernel=$(ec2-describe-images -o amazon --filter "manifest-location=*pv-grub-hd0_1.04-$arch*" --region "$region" | cut -f 2)
        echo "using PV-GRUB kernel $kernel"

        ami=$(ec2-register "$bucket/nixos.img.manifest.xml" -n "$name" -d "NixOS $system r$revision" -O "$EC2_ACCESS_KEY" -W "$EC2_SECRET_KEY" \
            --region "$region" --kernel "$kernel" | cut -f 2)

        echo "AMI ID is $ami"

        echo "  \"14.12\".\"$region\".s3 = \"$ami\";" >> ec2-amis.nix

        ec2-modify-image-attribute --region "$region" "$ami" -l -a all -O "$EC2_ACCESS_KEY" -W "$EC2_SECRET_KEY"

        for cp_region in us-east-1 us-west-1 us-west-2 eu-central-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1; do
          new_ami=$(aws ec2 copy-image --source-image-id $ami --source-region $region --region $cp_region --name "$name" | json ImageId)
          echo "  \"14.12\".\"$cp_region\".s3 = \"$new_ami\";" >> ec2-amis.nix  
        done
    done
}

buildAndUploadFor x86_64-linux x86_64
