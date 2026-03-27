{
  lib,
  stdenv,
  fetchFromGitHub,
  libglvnd,
  libxinerama,
  libxext,
  libx11,
}:

stdenv.mkDerivation {
  pname = "cnping";
  version = "1.0.0-unstable-2024-02-29";

  src = fetchFromGitHub {
    owner = "cntools";
    repo = "cnping";
    rev = "2498fa4df1b4eff0df1f75b5f393e620bafd6997";
    hash = "sha256-MMPLp/3GNal0AKkUgd850JrVjRO5rPHvbnOl1uogPCQ=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libglvnd
    libxinerama
    libxext
    libx11
  ];

  # The "linuxinstall" target won't work for us:
  # it tries to setcap and copy to a FHS directory
  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    cp cnping $out/bin/cnping
    cp cnping.1 $out/share/man/man1/cnping.1
  '';

  meta = {
    description = "Minimal Graphical IPV4 Ping Tool";
    homepage = "https://github.com/cntools/cnping";
    license = with lib.licenses; [
      mit
      bsd3
    ]; # dual licensed, MIT-x11 & BSD-3-Clause
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "cnping";
  };
}
