{ lib, stdenv, undmg, fetchurl }:
let
  common = import ./common.nix { inherit fetchurl; };
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation rec {
  inherit (common) pname version;
  src = common.sources.${system} or (throw "Source for ${pname} is not available for ${system}");

  appName = "Lens";

  sourceRoot = "${appName}.app";

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p "$out/Applications/${appName}.app"
    cp -R . "$out/Applications/${appName}.app"
  '';

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.lens;
    maintainers = with maintainers; [ dbirks ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
