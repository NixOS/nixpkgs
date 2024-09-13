{ lib
, cimg
, cmake
, curl
, fetchFromGitHub
, fftw
, gimp
, gimpPlugins
, gmic
, graphicsmagick
, libjpeg
, libpng
, libsForQt5
, libtiff
, ninja
, nix-update-script
, openexr
, pkg-config
, stdenv
, zlib
, variant ? "standalone"
}:

let
  variants = {
    gimp = {
      extraDeps = [
        gimp
        gimp.gtk
      ];
      description = "GIMP plugin for the G'MIC image processing framework";
    };

    standalone = {
      extraDeps = []; # Just to keep uniformity and avoid test-for-null
      description = "Versatile front-end to the image processing framework G'MIC";
    };
  };

in

assert lib.assertMsg
  (builtins.hasAttr variant variants)
  "gmic-qt variant \"${variant}\" is not supported. Please use one of ${lib.concatStringsSep ", " (builtins.attrNames variants)}.";

assert lib.assertMsg
  (builtins.all (d: d != null) variants.${variant}.extraDeps)
  "gmic-qt variant \"${variant}\" is missing one of its dependencies.";

stdenv.mkDerivation (finalAttrs: {
  pname = "gmic-qt${lib.optionalString (variant != "standalone") "-${variant}"}";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "c-koi";
    repo = "gmic-qt";
    rev = "v.${finalAttrs.version}";
    hash = "sha256-fM6dBxBC2b1/v+rfiP//QaAcTJmMtYPn4OUNwVqKhYk=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    ninja
    pkg-config
  ];

  buildInputs = [
    cimg
    curl
    fftw
    gmic
    graphicsmagick
    libjpeg
    libpng
    libtiff
    openexr
    zlib
  ] ++ (with libsForQt5; [
    qtbase
    qttools
  ]) ++ variants.${variant}.extraDeps;

  postPatch = ''
    patchShebangs \
      translations/filters/csv2ts.sh \
      translations/lrelease.sh

    mkdir ../src
    ln -s ${gmic.src}/src/gmic.cpp ../src/gmic.cpp
  '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_DYNAMIC_LINKING" true)
    (lib.cmakeBool "ENABLE_SYSTEM_GMIC" true)
    (lib.cmakeFeature "GMIC_QT_HOST" (if variant == "standalone" then "none" else variant))
  ];

  postFixup = lib.optionalString (variant == "gimp") ''
    echo "wrapping $out/${gimp.targetPluginDir}/gmic_gimp_qt/gmic_gimp_qt"
    wrapQtApp "$out/${gimp.targetPluginDir}/gmic_gimp_qt/gmic_gimp_qt"
  '';

  passthru = {
    tests = {
      # They need to be update in lockstep.
      gimp-plugin = gimpPlugins.gmic;
      inherit cimg gmic;
    };

    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "^v\\.(.*)" ];
    };
  };

  meta = {
    homepage = "http://gmic.eu/";
    inherit (variants.${variant}) description;
    license = lib.licenses.gpl3Plus;
    mainProgram = "gmic_qt";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
