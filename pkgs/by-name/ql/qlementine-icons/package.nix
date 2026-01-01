{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qlementine-icons";
<<<<<<< HEAD
  version = "1.13.0";
=======
  version = "1.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "oclero";
    repo = "qlementine-icons";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-wXpFyVTFNHTVkGz2fQ2gQHdvCfZNs6Dx8hhonFRZytg=";
=======
    hash = "sha256-Tx3CWEuLIAY8Wk5TUe9Z6+i579GVCr7Vbukzc21K26Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector icon set for modern desktop Qt5/Qt6 applications";
    longDescription = ''
      An icon set aimed to be used in conjunction with the Qlementine Qt library.

      This icon set provides icons as requested by the Freedesktop
      standard, and vastly expands it, in 16×16 pixels.

      The icons are in SVG format, so can be scaled to any size without
      loosing any quality. However, they've been designed to be used in
      `16×16` pixels, to be pixel-perfect.
    '';
    homepage = "https://github.com/oclero/qlementine-icons";
    changelog = "https://github.com/oclero/qlementine-icons/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = lib.platforms.unix;
  };
})
