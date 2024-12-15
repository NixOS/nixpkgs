{
  fetchFromGitHub,
  fzf,
  lib,
  rustPlatform,
  stdenv,
}:
let
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "dirStack";
    rev = "8ef0f19ae366868fb046f6acb0d396bc8436ef31";
    hash = "sha256-mzw3uDZ0eM81WJM0YNcOlMHs4fNMUBgwxS6VBSS+VS8=";
  };
  meta = with lib; {
    description = "A cd quicklist";
  meta = {
    description = "A fast directory navigation tool with a quicklist";
    longDescription = ''
      This utility allows you to change directories quickly using a user defined list of frequently used paths.
      It reduces the time spent on navigation and enhances workflow efficiency.
    '';
    homepage = "https://github.com/NewDawn0/dirStack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
  pkg = rustPlatform.buildRustPackage {
    inherit meta src;
    pname = "dirStack";
    version = "1.0.0";
    propagatedBuildInputs = [ fzf ];
    cargoLock.lockFile = "${src}/Cargo.lock";
  };
in
stdenv.mkDerivation {
  inherit meta;
  name = "dirStack-wrapped";
  version = "1.0.0";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp ${pkg}/bin/dirStack $out/bin/
    echo "#!/usr/bin/env bash" > $out/lib/SOURCE_ME.sh
    $out/bin/dirStack --init >> $out/lib/SOURCE_ME.sh
    chmod +x $out/lib/SOURCE_ME.sh
  '';
  shellHook = ''
    source $out/lib/SOURCE_ME.sh
  '';
}
