{ stdenv, fetchFromGitHub, makeWrapper, nx-libs, xorg, getopt, gnugrep, gawk, ps, mount, iproute }:
stdenv.mkDerivation rec {
  pname = "x11docker";
  version = "6.4.0";
  src = fetchFromGitHub {
    owner = "mviereck";
    repo = "x11docker";
    rev = "v${version}";
    sha256 = "0s8gk2kqxkfwx1x44g19ckm7rqgrcax59y8brgmigajqizik7sql";
  };
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  # Don't install `x11docker-gui`, because requires `kaptain` dependency
  installPhase = ''
    install -D x11docker "$out/bin/x11docker";
    wrapProgram "$out/bin/x11docker" \
      --prefix PATH : "${stdenv.lib.makeBinPath [ getopt gnugrep gawk ps mount iproute nx-libs xorg.xdpyinfo xorg.xhost xorg.xinit ]}"
  '';

  meta = {
    description = "Run graphical applications with Docker";
    homepage = https://github.com/mviereck/x11docker;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ jD91mZM2 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
