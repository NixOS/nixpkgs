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

stdenv.mkDerivation rec {
  pname = "duperemove";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    hash = "sha256-T17XkR6AUvOerg9FN4SxTfoMavVXnxujtrA4p4GEnFE=";
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
    "VERSION=v${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = duperemove;
    command = "duperemove --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = "https://github.com/markfasheh/duperemove";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      bluescreen303
      thoughtpolice
    ];
    platforms = platforms.linux;
    mainProgram = "duperemove";
  };
}
