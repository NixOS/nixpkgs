{
  stdenv,
  fetchFromGitHub,
  openttd-nml,
  python3,
  coreutils,
  gnutar,
  callPackage,
}:

let
  catcodec = callPackage ./catcodec.nix { };
in

stdenv.mkDerivation {
  pname = "openttd-opensfx";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "OpenSFX";
    tag = "1.0.3";
    hash = "sha256-VXxu6LD+TThHMY4PWjDtXTpochiMIch9Ru6G621P60o=";
  };

  nativeBuildInputs = [
    openttd-nml
    python3
    coreutils
    gnutar
    catcodec
  ];

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace-fail \
        'ifneq ("$(shell which $(MD5SUM) 2>/dev/null)","")' \
        'ifeq (1,1)'
  '';

  preBuild = ''
    printf '1.0.3\t20230404\t0\t' > .ottdrev
  '';

  makeFlags = [
    "bundle_tar"
    "PYTHON=python3"
    "MD5SUM=md5sum"
    "CP_FLAGS=-rf"
    "TAR=tar"
  ];

  installPhase = ''
    mkdir -p $out
    cp *.tar $out/
  '';
}
