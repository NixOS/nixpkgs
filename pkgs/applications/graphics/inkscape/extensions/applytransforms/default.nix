{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "inkscape-applytransforms";
  version = "0-unstable-2021-05-11";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Klowner";
    repo = "inkscape-applytransforms";
    rev = "5b3ed4af0fb66e399e686fc2b649b56db84f6042";
    hash = "sha256-XWwkuw+Um/cflRWjIeIgQUxJLrk2DLDmx7K+pMWvIlI=";
  };

  nativeCheckInputs = [
    python3Packages.inkex
    python3Packages.pytestCheckHook
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
