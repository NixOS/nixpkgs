{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  common-updater-scripts,
  coreutils,
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

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

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
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "openxcom";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
