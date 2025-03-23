#!/usr/bin/env bash

# This script updates the Solidity binary lists required by the svm-rs
# crate.
# TODO: Bundle this into an updater script

set -euo pipefail

# Get the directory of the current script
script_dir=$(dirname "$(realpath "$0")")

# Directory where the files will be downloaded
dir="${script_dir}/svm-lists"

# URLs of the files
urls=(
    "https://binaries.soliditylang.org/macosx-amd64/list.json"
    "https://binaries.soliditylang.org/linux-amd64/list.json"
)

# Create the directory (no error if it already exists)
mkdir -p "$dir"

# Function to extract filename from URL
extract_filename() {
    url=$1
    # Extract the parent directory name and append .json
    echo "$(basename "$(dirname "$url")").json"
}

# Function to fix line endings and remove trailing newline
ensure_unix_format() {
    file=$1
    # Convert to Unix LF line endings and ensure there's no trailing newline
    tr -d '\r' < "$file" | sed -e '$a\' > "${file}.tmp" && mv "${file}.tmp" "$file"
}

# Iterate over the URLs
for url in "${urls[@]}"; do
    # Extract filename from URL
    filename=$(extract_filename "$url")

    # Download the file and fix line endings
    echo "Fetching $url to $dir/$filename"
    curl -sL "$url" -o "${dir}/${filename}"
    ensure_unix_format "${dir}/${filename}"
done
