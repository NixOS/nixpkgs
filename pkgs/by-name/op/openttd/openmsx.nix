{
  stdenv,
  fetchFromGitHub,
  openttd-nml,
  python3,
  coreutils,
  gnutar,
}:

stdenv.mkDerivation {
  pname = "openttd-openmsx";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "OpenMSX";
    tag = "0.4.2";
    hash = "sha256-l5yD2+iTk/3xa5wBpg6SOY5sMUYpUnUtEaIOrKJqQio=";
  };

  nativeBuildInputs = [
    openttd-nml
    python3
    coreutils
    gnutar
  ];

  postPatch = ''
    substituteInPlace scripts/md5list.py \
      --replace-fail "md5call = [\"md5\", \"-r\"]" "md5call = [\"md5sum\"]"
  '';

  preBuild = ''
    printf '0.4.2\t20210601\t0\t' > .ottdrev
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
