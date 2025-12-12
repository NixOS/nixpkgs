unpackPhase
cd source
# this helper downloads the videojs files and checks their checksums
# against videojs-dependencies.yml so it should be pure
crystal run scripts/fetch-player-dependencies.cr -- --minified
rm -f assets/videojs/.gitignore
mv assets/videojs "$out"
