{
  stdenv,
  fetchFromGitHub,
  openttd-nml,
  openttd-grfcodec,
  python3,
  coreutils,
  gnutar,
}:

stdenv.mkDerivation {
  pname = "openttd-opengfx";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "OpenGFX";
    tag = "8.0";
    hash = "sha256-5kM+MlI+9xXX0igK6bywU1ebINjzUpvZwMes5/LqfmY=";
  };

  nativeBuildInputs = [
    openttd-nml
    openttd-grfcodec
    python3
    coreutils
    gnutar
  ];

  preBuild = ''
    printf '8.0\t20230404\t0\t' > .ottdrev
  '';

  makeFlags = [
    "bundle_tar"
    "MD5SUM=md5sum"
    "CP_FLAGS=-rf"
    "TAR=tar"
  ];

  installPhase = ''
    mkdir -p $out
    cp *.tar $out/
  '';
}
