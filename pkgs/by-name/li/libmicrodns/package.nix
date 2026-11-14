{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.2.0";
  pname = "libmicrodns";

  src = fetchFromGitHub {
    owner = "videolabs";
    repo = "libmicrodns";
    rev = finalAttrs.version;
    hash = "sha256-C/TVjsSmmeUTpPN2AqdXvVj93gJ/3YPJttkFVoiabxc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = {
    description = "Minimal mDNS resolver library, used by VLC";
    homepage = "https://github.com/videolabs/libmicrodns";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.shazow ];
  };
})
