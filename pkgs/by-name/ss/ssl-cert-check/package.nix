{
  lib,
  stdenv,
  coreutils,
  fetchFromGitHub,
  findutils,
  gawk,
  gnugrep,
  gnused,
  makeWrapper,
  mktemp,
  openssl,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ssl-cert-check";
  version = "4.14";

  src = fetchFromGitHub {
    owner = "Matty9191";
    repo = "ssl-cert-check";
    rev = "4056ceeab5abc0e39f4e0ea40cd54147253a3369";
    sha256 = "07k2n4l68hykraxvy030djc208z8rqff3kc7wy4ib9g6qj7s4mif";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    coreutils
    findutils
    gawk
    gnugrep
    gnused
    mktemp
    openssl
    which
  ];

  prePatch = ''
    substituteInPlace $pname --replace PATH= NOT_PATH=
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $pname $out/bin/$pname
    wrapProgram $out/bin/$pname \
      --set PATH "${lib.makeBinPath finalAttrs.buildInputs}"
  '';

  meta = {
    description = "Bourne shell script that can be used to report on expiring SSL certificates";
    mainProgram = "ssl-cert-check";
    homepage = "https://github.com/Matty9191/ssl-cert-check";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ryantm ];
    platforms = lib.platforms.linux;
  };
})
