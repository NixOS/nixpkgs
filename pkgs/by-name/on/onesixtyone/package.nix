{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "onesixtyone";
  version = "0.3.4-unstable-2025-08-30";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "onesixtyone";
    rev = "3bedd7cab7fe1bcfc2def208f87fbf10a013efc7";
    hash = "sha256-9gvulDEaEFZdGl/x5oNHTuMNbBK56dgOydQRyzGO29Q=";
  };

  buildPhase = ''
    $CC -o onesixtyone onesixtyone.c
  '';

  installPhase = ''
    install -D onesixtyone $out/bin/onesixtyone
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/trailofbits/onesixtyone";
    tagPrefix = "v";
    branch = "master"; # optional, defaults to default branch
  };

  meta = with lib; {
    description = "Fast SNMP Scanner";
    homepage = "https://github.com/trailofbits/onesixtyone";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.fishi0x01 ];
    mainProgram = "onesixtyone";
  };
}
