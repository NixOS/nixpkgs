{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  libgcrypt,
  xxhash,
  pkg-config,
  glib,
  linuxHeaders ? stdenv.cc.libc.linuxHeaders,
  sqlite,
  util-linux,
  versionCheckHook,
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

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libbsd
    libgcrypt
    glib
    linuxHeaders
    sqlite
    util-linux
    xxhash
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=v${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

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
