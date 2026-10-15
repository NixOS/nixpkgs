{
  libx11,
  libxfixes,
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "clipnotify";
  version = "0-unstable-2018-02-20";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = "clipnotify";
    rev = "9cb223fbe494c5b71678a9eae704c21a97e3bddd";
    hash = "sha256-tiHYF1GxG7RZvVEnTZlaHWuLx0FmGb7Y1oA/B7DcKvU=";
  };

  buildInputs = [
    libx11
    libxfixes
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp clipnotify $out/bin
  '';

  meta = {
    description = "Notify on new X clipboard events";
    inherit (finalAttrs.src.meta) homepage;
    maintainers = with lib.maintainers; [ jb55 ];
    license = lib.licenses.publicDomain;
    mainProgram = "clipnotify";
  };
})
