{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
  cmake,
  git,
  mmt-dpi,
  libxml2,
  libpcap,
  libconfuse,
  lksctp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "5greplay";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Montimage";
    repo = "5Greplay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c3lETZHb4ppB28P8HD+w9yz67t5g8J1jToTu4Trgq94=";
  };

  nativeBuildInputs = [
    gcc
    cmake
    git
    mmt-dpi
    libxml2
    libpcap
    libconfuse
    lksctp-tools
  ];

  configurePhase = ''
    make
  '';

  meta = {
    description = "Tool for modifying and replaying 5G protocol network traffic using attack injection and fuzzing";
    homepage = "https://github.com/Montimage/5Greplay";
    changelog = "https://github.com/Montimage/5Greplay/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
