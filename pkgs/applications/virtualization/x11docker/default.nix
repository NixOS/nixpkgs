{ stdenv, fetchFromGitHub, makeWrapper, nx-libs, xorg }:
stdenv.mkDerivation rec {
  pname = "x11docker";
  version = "6.2.0";
  src = fetchFromGitHub {
    owner = "mviereck";
    repo = "x11docker";
    rev = "v${version}";
    sha256 = "19q5vrhspxpjkdhhlgya2sa2fgjg8gyd3kmnb83nlfs46p8jx4f4";
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
