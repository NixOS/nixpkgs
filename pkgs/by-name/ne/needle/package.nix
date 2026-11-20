{
  stdenv,
  lib,
  fetchFromGitHub,
  swift,
  swiftpm,
  swiftpm2nix,
  sqlite,
}:
let
  generated = swiftpm2nix.helpers ./nix;
in
stdenv.mkDerivation rec {
  pname = "needle";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "uber";
    repo = "needle";
    rev = "v${version}";
    hash = "sha256-vQlUcfIj+LHZ3R+XwSr9bBIjcZUWkW2k/wI6HF+sDPo=";
  };

  sourceRoot = "${src.name}/Generator";

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  propagatedBuildInputs = [ sqlite ];

  configurePhase = generated.configure;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$(swiftpmBinPath)"/needle $out/bin/needle
    runHook postInstall
  '';

  meta = {
    description = "Compile-time safe Swift dependency injection framework";
    homepage = "https://github.com/uber/needle";
    license = lib.licenses.asl20;
    mainProgram = "needle";
    maintainers = with lib.maintainers; [ matteopacini ];
    platforms = lib.platforms.darwin;
  };
}
