{ callPackage, fetchFromGitHub, makeRustPlatform }:

{ date, channel }:

let
  mozillaOverlay = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "8c007b60731c07dd7a052cce508de3bb1ae849b4";
    sha256 = "1zybp62zz0h077zm2zmqs2wcg3whg6jqaah9hcl1gv4x8af4zhs6";
  };
  mozilla = callPackage "${mozillaOverlay.out}/package-set.nix" { };
  rustSpecific = (mozilla.rustChannelOf { inherit date channel; }).rust;
in makeRustPlatform {
  cargo = rustSpecific;
  rustc = rustSpecific;
}
