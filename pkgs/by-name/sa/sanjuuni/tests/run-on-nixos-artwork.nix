{
  runCommand,
  sanjuuni,
  nixos-artwork,
  lua5_2,
}:
let
  makeCommand = derivation: baseFilename: ''
    echo "sanjuuni-test-run-on-nixos-artwork: Running Sanjuuni on ${derivation}/share/backgrounds/nixos/${baseFilename}.png"
    sanjuuni --lua --disable-opencl \
      --input ${derivation}/share/backgrounds/nixos/${baseFilename}.png \
      --output $out/${baseFilename}.lua
    echo "sanjuuni-test-run-on-nixos-artwork: Checking syntax on $out/${baseFilename}.lua"
    lua -e "loadfile(\"$out/${baseFilename}.lua\")"
  '';
in
runCommand "sanjuuni-test-run-on-nixos-artwork"
  {
    nativeBuildInputs = [
      sanjuuni
      lua5_2
      nixos-artwork.wallpapers.simple-blue
      nixos-artwork.wallpapers.simple-red
      nixos-artwork.wallpapers.simple-dark-gray
      nixos-artwork.wallpapers.stripes
    ];
  }
  ''
    mkdir -p $out
    ${makeCommand nixos-artwork.wallpapers.simple-blue "nix-wallpaper-simple-blue"}
    ${makeCommand nixos-artwork.wallpapers.simple-red "nix-wallpaper-simple-red"}
    ${makeCommand nixos-artwork.wallpapers.simple-dark-gray "nix-wallpaper-simple-dark-gray"}
    ${makeCommand nixos-artwork.wallpapers.stripes "nix-wallpaper-stripes"}
  ''
