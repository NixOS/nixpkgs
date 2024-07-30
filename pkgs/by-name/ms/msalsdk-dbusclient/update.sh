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

    if ! [[ "$line" ]] && [[ "${Package}" == "msalsdk-dbusclient" ]]; then
        if ( dpkg --compare-versions ${Version} gt ${latest_version} ); then
            latest_version="${Version}"

            echo $latest_version
        fi

        Package=""
        Version=""
    fi
done | tail -n 1 | (read version; update-source-version msalsdk-dbusclient $version)
