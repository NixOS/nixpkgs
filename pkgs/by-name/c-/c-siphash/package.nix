{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  pkg-config,
  ninja,
  c-stdaux,
}:

stdenv.mkDerivation rec {
  pname = "c-siphash";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-siphash";
    tag = "v${version}";
    hash = "sha256-S5eAlLR6p0Tpd6aYPGGGOH1sCGOyflVyhICi2pYt/8U=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  propagatedBuildInputs = [ c-stdaux ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/c-util/c-siphash";
    description = "Streaming-capable SipHash Implementation";
    changelog = "https://github.com/c-util/c-siphash/releases/tag/${src.tag}";
    license = with lib.licenses; [
      asl20
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
