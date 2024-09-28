{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
let
  version = "4.2.5";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-gui-common";
    rev = "refs/tags/v${version}";
    hash = "sha256-rv80X/wecXRtJ3HhHgksJd43AKvLQTHyX8e1EJPwEO0=";
  };
in
stdenvNoCC.mkDerivation {
  inherit version src;
  name = "qubes-gui-common";

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out
    cp -r include $out/
  '';
}
