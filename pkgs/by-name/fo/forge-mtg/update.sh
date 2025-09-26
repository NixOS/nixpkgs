#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p curl cacert nix-update jq gnused git

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_latest_version() {
    local repo="$1"
    curl -sfS ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/$repo/releases/latest | jq -r .tag_name
}

download_and_extract_source() {
    local repo="$1"
    local version="$2"
    local temp_dir=$(mktemp -d)

    curl -sfSL "https://github.com/$repo/archive/$version.tar.gz" | tar -xz -C "$temp_dir"

    echo $temp_dir
}

check_plugin_in_pom() {
    local pom_file="$1"
    local plugin_name="$2"
    if [[ -f "$pom_file" ]]; then
        grep -q "<artifactId>$plugin_name</artifactId>" "$pom_file" 2>/dev/null
    else
        return 1
    fi
}

remove_plugin_from_pom() {
    local pom_file="$1"
    local plugin_name="$2"

    if [[ ! -f "$pom_file" ]]; then
        echo "Error: $pom_file does not exist" >&2
        return 1
    fi

    awk -v plugin="$plugin_name" '
    /<plugin>/ {
        plugin_block = $0 "\n"
        in_plugin = 1
        skip = 0
        next
    }
    in_plugin && /<\/plugin>/ {
        plugin_block = plugin_block $0 "\n"
        if (!skip) {
            printf "%s", plugin_block
        }
        in_plugin = 0
        plugin_block = ""
        next
    }
    in_plugin {
        plugin_block = plugin_block $0 "\n"
        if (/<artifactId>/ && index($0, plugin) > 0) {
            skip = 1
        }
        next
    }
    !in_plugin { print }
    ' "$pom_file" > "$pom_file.tmp" && mv "$pom_file.tmp" "$pom_file"

    echo "Removed plugin blocks with artifactId '$plugin_name' from $pom_file"
}

update_patch() {
    local source_dir="$1"
    local plugin_name="$2"
    local patch_file="$3"

    if [[ ! -d "$source_dir" ]]; then
        echo "Source directory $source_dir does not exist!"
        exit 1
    fi

    local temp_dir=$(mktemp -d)
    local plugin_found=false
    local patch_content=""

    echo "Checking for $plugin_name in pom.xml files..."

    # Find all pom.xml files that contain the specified plugin
    while IFS= read -r -d '' pom_file; do
        if check_plugin_in_pom "$pom_file" "$plugin_name"; then
            plugin_found=true
            echo "Found $plugin_name in: $pom_file"

            # Generate patch content for this file
            local relative_path=$(echo "$pom_file" | sed "s|^$source_dir/||")
            local temp_original="$temp_dir/original_$(basename "$pom_file")"
            local temp_patched="$temp_dir/patched_$(basename "$pom_file")"

            cp "$pom_file" "$temp_original"
            cp "$pom_file" "$temp_patched"

            remove_plugin_from_pom "$temp_patched" "$plugin_name"

            # Generate diff for this file
            if ! cmp -s "$temp_original" "$temp_patched"; then
                local file_diff=$(diff -u "$temp_original" "$temp_patched" | sed "s|$temp_original|a/$relative_path|g; s|$temp_patched|b/$relative_path|g" | sed '1,2s/\t.*$//')
                if [[ -n "$file_diff" ]]; then
                    patch_content+='diff --git a/'"$relative_path"' b/'"$relative_path"''$'\n'
                    patch_content+="$file_diff"$'\n'
                fi
            fi
        fi
    done < <(find "$source_dir" -name "pom.xml" -print0)

    if [[ "$plugin_found" == "true" && -n "$patch_content" ]]; then
        echo "Updating $patch_file..."
        echo "$patch_content" > "$SCRIPT_DIR/$patch_file"
        echo "Patch updated successfully!"
        rm -rf "$temp_dir"
    else
        echo "No $plugin_name found on any pom.xml file. Patch not updated."
        rm -rf "$temp_dir"
        exit 1
    fi
}

echo "Updating forge-mtg package..."

version=$(get_latest_version "Card-Forge/forge")

source_dir=$(download_and_extract_source "Card-Forge/forge" $version)/forge-$version

update_patch "$source_dir" "launch4j-maven-plugin" "no-launch4j.patch"

rm -rf "$(dirname "$source_dir")"

nix-update --version-regex=forge-'(.*)' forge-mtg
