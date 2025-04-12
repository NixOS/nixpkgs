{
  lib,
  stdenv,
  fetchFromGitHub,
  libglvnd,
  xorg,
}:

stdenv.mkDerivation rec {
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
    xorg.libXinerama
    xorg.libXext
    xorg.libX11
  ];

  # The "linuxinstall" target won't work for us:
  # it tries to setcap and copy to a FHS directory
  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    cp cnping $out/bin/cnping
    cp cnping.1 $out/share/man/man1/cnping.1
  '';

  meta = with lib; {
    description = "Minimal Graphical IPV4 Ping Tool";
    homepage = "https://github.com/cntools/cnping";
    license = with licenses; [
      mit
      bsd3
    ]; # dual licensed, MIT-x11 & BSD-3-Clause
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "cnping";
  };
}
