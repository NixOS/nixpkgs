{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  common-updater-scripts,
  coreutils,
  desktopToDarwinBundle,
  git,
  gnused,
  libGL,
  libGLU,
  pkg-config,
  SDL_gfx,
  SDL_image,
  SDL_mixer,
  sdl12-compat,
  versionCheckHook,
  writeShellScript,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openxcom-extended";
  version = "8.7.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "MeridianOXC";
    repo = "OpenXcom";
    rev = "441cae1b071d249d40a223858cb6bd07fd5d791b";
    hash = "sha256-SGLZGguLzBp4A4RpkpYzvjagNmxPpTzrLWblMwqE9OI=";
  };

  patches = [
    # Keep saves and options.cfg apart from openxcom's, which can't load OXCE
    # saves. The original game files are still found in openxcom's user folder.
    ./separate-user-folder.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  # The terminal font is blitted onto a surface with only 2 palette entries set.
  # SDL 1.2 left the rest black, but sdl12-compat inherits SDL2's all-white
  # default, so the glyphs map to an index the screen never gets a color for
  # and the startup/error screen renders black on black.
  postPatch = ''
    substituteInPlace src/Engine/Font.cpp \
      --replace-fail \
        'image.surface = new Surface(s->w, s->h);' \
        'image.surface = new Surface(s->w, s->h); { SDL_Color black[256] = {}; image.surface->setPalette(black, 0, 256); }'

    # Install the data next to, not on top of, openxcom's, and look for it
    # there in profiles too, so openxcom's data is never picked up instead
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'DATADIR}/openxcom"' 'DATADIR}/openxcom-extended"'
    substituteInPlace src/Engine/CrossPlatform.cpp \
      --replace-fail '"%s/openxcom/", dir' '"%s/openxcom-extended/", dir' \
      --replace-fail '"/../share/openxcom/"' '"/../share/openxcom-extended/"'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Don't replace the Dock icon with the raw window icon, so macOS keeps
    # showing the app bundle's icon, styled like other apps
    substituteInPlace src/Engine/CrossPlatform.cpp \
      --replace-fail 'SDL_WM_SetIcon(icon, NULL);' ""
  '';

  buildInputs = [
    SDL_gfx
    SDL_image
    SDL_mixer
    sdl12-compat
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libGLU
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [ (lib.cmakeBool "CREATE_BUNDLE" false) ];

  # Rename everything that would collide with openxcom
  postInstall = ''
    mv $out/bin/openxcom $out/bin/openxcom-extended
    mv $out/share/applications/openxcom.desktop $out/share/applications/openxcom-extended.desktop
    substituteInPlace $out/share/applications/openxcom-extended.desktop \
      --replace-fail 'Name=OpenXcom' 'Name=OpenXcom Extended' \
      --replace-fail 'Exec=openxcom' 'Exec=openxcom-extended' \
      --replace-fail 'Icon=openxcom' 'Icon=openxcom-extended'
    for icon in $out/share/icons/hicolor/*/apps/openxcom.*; do
      mv "$icon" "''${icon/openxcom./openxcom-extended.}"
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mv $out/share/man/man6/openxcom.6 $out/share/man/man6/openxcom-extended.6
  '';

  # desktopToDarwinBundle only scales up the 128x128 PNG, use upstream's icon
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp ${finalAttrs.src}/res/mac/AppIcon.icns "$out/Applications/OpenXcom Extended.app/Contents/Resources/openxcom-extended.icns"
  '';

  doInstallCheck = !stdenv.hostPlatform.isDarwin;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = writeShellScript "update-openxcom-extended" ''
    set -euo pipefail
    export PATH=${
      lib.makeBinPath [
        common-updater-scripts
        coreutils
        git
        gnused
      ]
    }:$PATH

    repo=$(mktemp -d)
    trap 'rm -rf "$repo"' EXIT
    git clone --quiet --bare --single-branch --branch oxce-plus \
      https://github.com/MeridianOXC/OpenXcom.git "$repo"

    rev=$(git -C "$repo" log -1 --format=%H -G OPENXCOM_VERSION_SHORT -- src/version.h)
    version=$(
      git -C "$repo" show "$rev:src/version.h" \
        | sed -nE 's/^#define OPENXCOM_VERSION_SHORT "Extended ([^"]+)"/\1/p'
    )

    update-source-version openxcom-extended "$version" --rev="$rev"
  '';

  meta = {
    description = "Extended fork of OpenXcom, an open source clone of UFO: Enemy Unknown and X-COM: Terror From the Deep";
    longDescription = ''
      OpenXcom Extended (OXCE) is a fork of OpenXcom, an open source clone of
      UFO: Enemy Unknown (X-COM: UFO Defense) and X-COM: Terror From the Deep,
      with many more features and modding capabilities. It requires the data
      files from either or both of the original games.

      It is the version recommended by the OpenXcom developers, while
      OpenXcom itself is kept as a legacy version.
    '';
    homepage = "https://openxcom.org/";
    downloadPage = "https://openxcom.org/oxce/release/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      keenanweaver
      iedame
    ];
    mainProgram = "openxcom-extended";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
