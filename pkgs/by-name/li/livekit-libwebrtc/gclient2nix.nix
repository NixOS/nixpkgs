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
  nixfmt-rfc-style,
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
    nixfmt-rfc-style
  ];
in
buildPythonPackage {
  pname = "gclient2nix";
  version = "0.2.0-unstable-2024-12-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeetHet";
    repo = "gclient2nix";
    rev = "bdf5ab79818595be9dcfc655bd6784cf4bcdb863";
    hash = "sha256-KOXG8E2g30XyZGmM4ZnYPBSybBhHIjOZL8ZXRKYrkZQ=";
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
