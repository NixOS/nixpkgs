#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl gzip

# To update: ./update.sh > default.nix

index_file=$(curl -sL https://packages.microsoft.com/repos/edge/dists/stable/main/binary-amd64/Packages.gz | gzip -dc)

echo "{"

packages=()
echo "$index_file" | while read -r line; do
    if [[ "$line" =~ ^Package:[[:space:]]*(.*) ]]; then
        Package="${BASH_REMATCH[1]}"
    fi
    if [[ "$line" =~ ^Version:[[:space:]]*(.*)-([a-zA-Z0-9+.~]*) ]]; then
        Version="${BASH_REMATCH[1]}"
        Revision="${BASH_REMATCH[2]}"
    fi
    if [[ "$line" =~ ^SHA256:[[:space:]]*(.*) ]]; then
        SHA256="${BASH_REMATCH[1]}"
    fi

    if ! [[ "$line" ]]; then
        found=0
        for i in "${packages[@]}"; do
            if [[ "$i" == "$Package" ]]; then
                found=1
            fi
        done

        if (( ! $found )); then
            channel="${Package##*-}"
            name="${Package%-${channel}}"
            cat <<EOF
  ${channel} = import ./browser.nix {
    channel = "${channel}";
    version = "${Version}";
    revision = "${Revision}";
    sha256 = "sha256:$(nix-hash --type sha256 --to-base32 ${SHA256})";
  };
EOF
        fi

        packages+=($Package)
        Package=""
        Version=""
    fi
done

echo "}"
