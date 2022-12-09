#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p cacert bundix bundler

# Do these steps before running this script:
#   1. Copy Gemfile from new Redmine version to this folder
#   2. Manually modify the database lines in Gemfile (diff the two files, it's obvious)

pkg_dir="$(dirname "$0")"
cd ${pkg_dir}

for file in "gemset.nix" "Gemfile.lock"; do
  if [ -f ${file} ]; then
    rm ${file}
  fi
done

bundle lock --add-platform ruby
bundle lock --remove-platform x86_64-linux
bundix -l
