{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkgs,
  pkg-config,
  ninja,
  libcstdaux,
}:

stdenv.mkDerivation rec {
  pname = "libcsiphash";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-siphash";
    tag = "v${version}";
    sha256 = "sha256-S5eAlLR6p0Tpd6aYPGGGOH1sCGOyflVyhICi2pYt/8U=";
  };

  nativeBuildInputs = [
    pkgs.meson
    pkg-config
    ninja
  ];

  buildInputs = [ libcstdaux ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/c-util/c-siphash";
    description = "Streaming-capable SipHash Implementation";
    changelog = "https://github.com/c-util/c-siphash/releases/tag/${src.tag}";
    license = with lib.licenses; [
      asl20
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
