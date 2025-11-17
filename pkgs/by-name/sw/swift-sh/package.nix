{
  lib,
  stdenv,
  swift,
  swiftpm,
  swiftpm2nix,
  fetchFromGitHub,
}:

let
  generated = swiftpm2nix.helpers ./nix;

in
stdenv.mkDerivation rec {
  pname = "swift-sh";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "mxcl";
    repo = "swift-sh";
    rev = version;
    hash = "sha256-Xj+2KjYRPOjwm10qWBSsJmk77ggH35hg4EteD/NmcE0=";
  };

  nativeBuildInputs = [
    swift
    swiftpm
  ];
  configurePhase = generated.configure;

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    cp $binPath/swift-sh $out/bin/
  '';

  meta = {
    description = "Easily script with third-party Swift dependencies.";
    homepage = "https://github.com/mxcl/swift-sh";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ jaekong ];
  };
}
