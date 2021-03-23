{ lib, stdenv, fetchFromGitHub, makeWrapper, nx-libs, xorg, getopt, gnugrep, gawk, ps, mount, iproute }:
stdenv.mkDerivation rec {
  pname = "x11docker";
  version = "6.6.2";
  src = fetchFromGitHub {
    owner = "mviereck";
    repo = "x11docker";
    rev = "v${version}";
    sha256 = "1skdgr2hipd7yx9c7r7nr3914gm9cm1xj6h3qdsa9f92xxm3aml1";
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
