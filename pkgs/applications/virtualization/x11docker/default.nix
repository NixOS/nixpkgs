{ lib, stdenv, fetchFromGitHub, makeWrapper, nx-libs, xorg, getopt, gnugrep, gawk, ps, mount, iproute }:
stdenv.mkDerivation rec {
  pname = "x11docker";
  version = "6.7.0";
  src = fetchFromGitHub {
    owner = "mviereck";
    repo = "x11docker";
    rev = "v${version}";
    sha256 = "sha256-AyP56wuu1IdWbxxxaDvgtgX52hA1A9Ay049awcx43Gk=";
  };
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  # Don't install `x11docker-gui`, because requires `kaptain` dependency
  installPhase = ''
    install -D x11docker "$out/bin/x11docker";
    wrapProgram "$out/bin/x11docker" \
      --prefix PATH : "${lib.makeBinPath [ getopt gnugrep gawk ps mount iproute nx-libs xorg.xdpyinfo xorg.xhost xorg.xinit ]}"
  '';

  meta = {
    description = "Run graphical applications with Docker";
    homepage = "https://github.com/mviereck/x11docker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
