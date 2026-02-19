{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  libgcrypt,
  xxHash,
  pkg-config,
  glib,
  linuxHeaders ? stdenv.cc.libc.linuxHeaders,
  sqlite,
  util-linux,
  testers,
  duperemove,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "duperemove";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y3HIqq61bLfZi4XR2RtSyuCPmcWrTxeWvqpTh+3hUjc=";
  };

  postPatch = ''
    substituteInPlace util.c --replace \
      "lscpu" "${lib.getBin util-linux}/bin/lscpu"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libbsd
    libgcrypt
    glib
    linuxHeaders
    sqlite
    util-linux
    xxHash
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=v${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = duperemove;
    command = "duperemove --version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = "https://github.com/markfasheh/duperemove";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      thoughtpolice
    ];
    platforms = lib.platforms.linux;
    mainProgram = "duperemove";
  };
})
