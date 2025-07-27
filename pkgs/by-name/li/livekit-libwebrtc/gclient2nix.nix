{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  click,
  nurl,
  nix-prefetch-git,
  nix,
  coreutils,
  nixfmt,
  makeWrapper,
}:
# Based on https://github.com/milahu/gclient2nix
# but with libwebrtc-specific changes.
let
  nativeDeps = [
    nurl
    nix-prefetch-git
    nix
    coreutils
    nixfmt
  ];
in
buildPythonPackage {
  pname = "gclient2nix";
  version = "0.2.0-unstable-2025-04-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeetHet";
    repo = "gclient2nix";
    rev = "ec5fff1082cd4fff352e4c57baf9b1a7dbbcc94b";
    hash = "sha256-BK8GUpuqFOeK5d5wKVFYCfR5f6jCrke/2xxoVlmKpRI=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    click
  ];

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/gclient2nix \
      --set PATH ${lib.makeBinPath nativeDeps}
  '';

  meta = {
    description = "Generate Nix expressions for projects based on the Google build tools";
    homepage = "https://github.com/WeetHet/gclient2nix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      WeetHet
    ];
    mainProgram = "gclient2nix";
  };
}
