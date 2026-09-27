{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  libwebp,
  libtiff,
  libjpeg,
  libpng,
  zlib,
  libepoxy,
  libGL,
  glm,
  openmptSupport ? false,
  libopenmpt,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    root = "${finalAttrs.src}/Hurrican";
    iconName = "hurrican";
  in
  {
    pname = "hurrican";
    version = "0-unstable-2026-04-05";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "HurricanGame";
      repo = "Hurrican";
      rev = "0d91d1f2d40f38d21e7f41afc01369ee55649fb6";
      fetchSubmodules = true;
      hash = "sha256-pSC0+Ae3tP+SQnOvnZIKQyQgl528oictOF98v6lyZOA=";
    };

    postUnpack = ''
      sourceRoot="$sourceRoot/Hurrican"
    '';

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
      copyDesktopItems
    ];

    strictDeps = true;

    buildInputs = [
      SDL2
      SDL2_image
      SDL2_mixer
      libwebp
      libtiff
      libjpeg
      libpng
      zlib
      glm
      libepoxy
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux libGL
    ++ lib.optional openmptSupport libopenmpt;

    cmakeFlags =
      lib.optionals stdenv.hostPlatform.isDarwin [
        # macOS Core Profile rejects GLES-style #version 110 shaders (see data/shaders/100/).
        "-DRENDERER=GL3"
      ]
      ++ lib.optional openmptSupport (lib.cmakeBool "OPENMPT" true);

    env.NIX_CFLAGS_COMPILE = toString [
      "-I${lib.getDev SDL2}/include/SDL2"
      "-I${lib.getDev SDL2_image}/include/SDL2"
      "-I${lib.getDev SDL2_mixer}/include/SDL2"
      "-isystem ${glm}/include"
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "hurrican";
        desktopName = "Hurrican";
        comment = "Jump-and-shoot game inspired by the Turrican series";
        icon = iconName;
        exec = finalAttrs.meta.mainProgram;
        categories = [ "Game" ];
      })
    ];

    postInstall = ''
      install -D -m644 "${root}/data/textures/hurrican-logo.png" \
        "$out/share/icons/hicolor/256x256/apps/${iconName}.png"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      app="$out/Applications/Hurrican.app/Contents"
      mkdir -p "$app/MacOS" "$app/Resources"
      install -m644 "${root}/darwin/Hurrican.icns" "$app/Resources/Hurrican.icns"

      substitute "${root}/darwin/Hurrican-Info.plist" "$app/Info.plist" \
        --subst-var-by HURRICAN_BUNDLE_VERSION "${finalAttrs.version}"

      printf 'APPL????' > "$app/PkgInfo"

      ln -sf "$out/bin/${finalAttrs.meta.mainProgram}" "$app/MacOS/${finalAttrs.meta.mainProgram}"
    '';

    meta = {
      description = "Jump-and-shoot game inspired by the Turrican series";
      homepage = "https://github.com/HurricanGame/Hurrican";
      changelog = "https://github.com/HurricanGame/Hurrican/tags";
      longDescription = ''
        Community-maintained Hurrican fork with SDL2, optional OpenMPT music, and XDG paths on Unix.
        The original Windows binary was credited to Poke53280 / Winterworks as freeware; this
        upstream repository publishes full source — check the readme and code headers for wording.
        SPDX license metadata is inconsistent across files, so packaged as permissive OSS (MIT-like)
        pending upstream SPDX cleanup.
      '';
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ philocalyst ];
      mainProgram = "hurrican";
      platforms = lib.platforms.unix;
    };
  }
)
