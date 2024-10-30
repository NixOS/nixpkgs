#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl gzip dpkg common-updater-scripts

index_file=$(curl -sL https://packages.microsoft.com/ubuntu/22.04/prod/dists/jammy/main/binary-amd64/Packages.gz | gzip -dc)

latest_version="0"

echo "$index_file" | while read -r line; do
    if [[ "$line" =~ ^Package:[[:space:]]*(.*) ]]; then
        Package="${BASH_REMATCH[1]}"
    fi
    if [[ "$line" =~ ^Version:[[:space:]]*(.*) ]]; then
        Version="${BASH_REMATCH[1]}"
    fi
    if [[ "$line" =~ ^SHA256:[[:space:]]*(.*) ]]; then
        SHA256="${BASH_REMATCH[1]}"
    fi

    if ! [[ "$line" ]] && [[ "${Package}" == "microsoft-identity-broker" ]]; then
        if ( dpkg --compare-versions ${Version} gt ${latest_version} ); then
            latest_version="${Version}"
            sri_hash=$(nix-hash --to-sri --type sha256 "$SHA256")

            echo $latest_version $sri_hash
        fi

        Package=""
        Version=""
    fi
done | tail -n 1 | (read version hash; update-source-version microsoft-identity-broker $version $hash)
