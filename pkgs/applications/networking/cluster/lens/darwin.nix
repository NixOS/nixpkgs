{ lib, stdenv, undmg, fetchurl }:
<<<<<<< HEAD
let
  common = import ./common.nix { inherit fetchurl; };
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation rec {
  inherit (common) pname version;
  src = common.sources.${system} or (throw "Source for ${pname} is not available for ${system}");

=======

stdenv.mkDerivation rec {
  pname = "lens";
  version = "2022.12";
  build = "${version}.11410-latest";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  appName = "Lens";

  sourceRoot = "${appName}.app";

<<<<<<< HEAD
=======
  src = fetchurl {
    url = "https://api.k8slens.dev/binaries/Lens-${build}-arm64.dmg";
    sha256 = "sha256-PKWJ2CZ/wacbJnrCZdYwYJzbFVhjIGAw60UGhdw11Mc=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${appName}.app"
    cp -R . "$out/Applications/${appName}.app"
  '';

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
<<<<<<< HEAD
    license = licenses.lens;
    maintainers = with maintainers; [ dbirks ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
    platforms = [ "aarch64-darwin" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
