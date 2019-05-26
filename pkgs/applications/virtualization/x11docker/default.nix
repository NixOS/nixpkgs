{ stdenv, fetchFromGitHub, makeWrapper, nx-libs, xorg }:
stdenv.mkDerivation rec {
  name = "x11docker-${version}";
  version = "5.4.4";
  src = fetchFromGitHub {
    owner = "mviereck";
    repo = "x11docker";
    rev = "v${version}";
    sha256 = "1p45dyd1zfjxlawsy190q71hwl083f90ryaslslhxsadsi9m64dq";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nx-libs xorg.xhost xorg.xinit ];

  dontBuild = true;

  PATH_PREFIX = "${nx-libs}/bin:${xorg.xdpyinfo}/bin:${xorg.xhost}/bin:${xorg.xinit}/bin";

  installPhase = ''
    install -D x11docker "$out/bin/x11docker";
    #install -D x11docker-gui "$out/bin/x11docker-gui";
    wrapProgram "$out/bin/x11docker" --prefix PATH : "${PATH_PREFIX}"
    #wrapProgram "$out/bin/x11docker-gui" --prefix PATH : "${PATH_PREFIX}"
    # GUI disabled because of missing `kaptain` dependency
  '';

  meta = {
    description = "Run graphical applications with Docker";
    homepage = https://github.com/mviereck/x11docker;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ jD91mZM2 ];
  };
}
