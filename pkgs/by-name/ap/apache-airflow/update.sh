#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl pcre "python3.withPackages (ps: with ps; [ pyyaml ])" yarn2nix

set -euo pipefail

# Get new version
new_version="$(curl -s https://airflow.apache.org/docs/apache-airflow/stable/release_notes.html |
  pcregrep -o1 'Airflow ([0-9.]+).' | head -1)"
update-source-version apache-airflow "$new_version"

# Update frontend
cd ./pkgs/servers/apache-airflow
curl -O https://raw.githubusercontent.com/apache/airflow/$new_version/airflow/www/yarn.lock
curl -O https://raw.githubusercontent.com/apache/airflow/$new_version/airflow/www/package.json
yarn2nix > yarn.nix

# update provider dependencies
./update-providers.py
