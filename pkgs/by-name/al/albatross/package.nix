{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "Albatross";
  version = "1.7.4";

  src = fetchFromGitHub {
    repo = "Albatross";
    owner = "shimmerproject";
    tag = "v${version}";
    hash = "sha256-CHV68FwNy1uHzd2pEKGkSmJbLBFbHVPyt4T4DoU9CFc=";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes/Albatross
    cp -dr --no-preserve='ownership' {LICENSE.GPL,README,index.theme,gtk-2.0,gtk-3.0,metacity-1,xfwm4} $out/share/themes/Albatross/
  '';

  meta = {
    description = "Desktop Suite for Xfce";
    homepage = "https://github.com/shimmerproject/Albatross";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
