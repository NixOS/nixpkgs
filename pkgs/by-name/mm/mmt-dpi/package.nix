{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
  cmake,
  git,
  libxml2,
  libpcap,
  libnghttp2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mmt-dpi";
  version = "1.7.10";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Montimage";
    repo = "mmt-dpi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m+7Trr38c8jdB+24sWYJSIoVhTkVhZ6rcGazxDprUu4=";
  };

  nativeBuildInputs = [
    gcc
    cmake
    git
    libxml2
    libpcap
    libnghttp2
  ];

  configurePhase = ''
    cd sdk
    make
  '';

  meta = {
    description = "High-performance C library for deep packet inspection (DPI), designed to extract data attributes from network packets, server logs, and structured events for real-time traffic analysis";
    homepage = "https://github.com/Montimage/mmt-dpi";
    changelog = "https://github.com/Montimage/mmt-dpi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
