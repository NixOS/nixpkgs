{
  lib,
  stdenv,
  fetchFromGitHub,
  lcms,
  cmake,
  pkg-config,
  qt6,
  wrapGAppsHook3,
  openjpeg,
  onetbb,
  blend2d,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdf4qt";
<<<<<<< HEAD
  version = "1.5.2.0";
=======
  version = "1.5.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "JakubMelka";
    repo = "PDF4QT";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-pY1PM3H9vANxogRzQvuIohIi9d8TL093kMAl49trTho=";
  };

  patches = [
    # https://github.com/JakubMelka/PDF4QT/pull/322
    ./migrated_to_blend2d_0.21.x.patch
=======
    hash = "sha256-Ysrz/uCSTFK5wGNdTXhpq6QVf7Ju1xWisNVUtBtdEjc=";
  };

  patches = [
    # lcms2 cmake module only appears when built with vcpkg.
    # We directly search for the corresponding libraries and
    # header files instead.
    ./find_lcms2_path.patch
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
    # GLib-GIO-ERROR: No GSettings schemas are installed on the system
    wrapGAppsHook3
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    qt6.qtsvg
    qt6.qtspeech
    lcms
    openjpeg
    onetbb
    blend2d
  ];

<<<<<<< HEAD
  # `blend2d.h` moved to `blend2d/blend2d.h` in blend2d >= 0.21.2
  NIX_CFLAGS_COMPILE = "-I${blend2d.dev}/include/blend2d";

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmakeFlags = [
    (lib.cmakeBool "PDF4QT_INSTALL_TO_USR" false)
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=(''${gappsWrapperArgs[@]})
  '';

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Open source PDF editor";
    longDescription = ''
      This software is consisting of PDF rendering library,
      and several applications, such as advanced document
      viewer, command line tool, and document page
      manipulator application. Software is implementing PDF
      functionality based on PDF Reference 2.0.
    '';
    homepage = "https://jakubmelka.github.io";
    changelog = "https://github.com/JakubMelka/PDF4QT/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "Pdf4QtViewer";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
