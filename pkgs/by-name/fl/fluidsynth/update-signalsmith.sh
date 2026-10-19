#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnugrep gnused nix nurl

set -euo pipefail

nixFile=pkgs/by-name/fl/fluidsynth/package.nix
cmakeLists=$(nix-build --no-out-link -A fluidsynth.src)/signalsmith-audio-basics/CMakeLists.txt

for attr in signalsmith-linear signalsmith-dsp signalsmith-hilbert; do
  repo=$(nix-instantiate --eval --raw -A "fluidsynth.$attr.repo")
  oldTag=$(nix-instantiate --eval --raw -A "fluidsynth.$attr.tag")
  oldHash=$(nix-instantiate --eval --raw -A "fluidsynth.$attr.outputHash")

  newTag=$(grep -A1 "Signalsmith-Audio/$repo.git" "$cmakeLists" | grep -oP 'GIT_TAG\s+\K\S+')
  if [[ $newTag == "$oldTag" ]]; then
    continue
  fi
  newHash=$(nurl --hash "https://github.com/Signalsmith-Audio/$repo" "$newTag")

  sed -i \
    -e "/repo = \"$repo\";/{n;s|\"$oldTag\"|\"$newTag\"|}" \
    -e "s|$oldHash|$newHash|" \
    "$nixFile"
done
