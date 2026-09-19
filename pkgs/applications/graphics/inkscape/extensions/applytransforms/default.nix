{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation {
  pname = "inkscape-applytransforms";
  version = "0.pre+unstable=2024-12-19";

  src = fetchFromGitHub {
    owner = "Klowner";
    repo = "inkscape-applytransforms";
    rev = "979f98dfe199d25ceecff68a86684b941e703e18";
    hash = "sha256-vRhNsHx5QkJPQgeToh4GRKD7EpMwLnN8QhrAP0WWTjU=";
  };

  nativeCheckInputs = [
    python3.pkgs.inkex
    python3.pkgs.pytestCheckHook
  ];

  dontBuild = true;

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dt "$out/share/inkscape/extensions" *.inx *.py

    runHook postInstall
  '';

  meta = {
    description = "Inkscape extension which removes all matrix transforms by applying them recursively to shapes";
    homepage = "https://github.com/Klowner/inkscape-applytransforms";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.all;
  };
}
