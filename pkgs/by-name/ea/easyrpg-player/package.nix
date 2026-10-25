{
  lib,
  stdenv,
  fetchFromGitHub,
  _experimental-update-script-combinators,
  alsa-lib,
  asciidoctor,
  cmake,
  flac,
  fluidsynth,
  fmt,
  freetype,
  glib,
  harfbuzz,
  lhasa,
  liblcf,
  libpng,
  libsndfile,
  libsysprof-capture,
  libvorbis,
  libxmp,
  mpg123,
  nix-update-script,
  nlohmann_json,
  opusfile,
  pcre2,
  pixman,
  pkg-config,
  sdl3,
  speexdsp,
  versionCheckHook,
  wildmidi,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "easyrpg-player";
  version = "0.8.1.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    tag = finalAttrs.version;
    hash = "sha256-fYSpFhqETkQhRK1/Uws0fWWdCr35+1J4vCPX9ZiQ3ZA=";
  };

  nativeBuildInputs = [
    asciidoctor
    cmake
    pkg-config
  ];

  buildInputs = [
    flac # needed by libsndfile
    fluidsynth
    fmt
    freetype
    glib
    harfbuzz
    lhasa
    liblcf
    libpng
    libsndfile
    libsysprof-capture # needed by glib
    libvorbis
    libxmp
    mpg123
    nlohmann_json
    opusfile
    pcre2 # needed by glib
    pixman
    sdl3
    speexdsp
    wildmidi
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  cmakeFlags = [
    (lib.cmakeBool "PLAYER_ENABLE_TESTS" finalAttrs.doCheck)
    # TODO: remove the below once SDL3 becomes default next major release
    (lib.cmakeFeature "PLAYER_TARGET_PLATFORM" "SDL3")
    # Defaults to the build date, which is always 1980-01-01 in the sandbox
    (lib.cmakeFeature "PLAYER_VERSION_APPEND" "")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/bin
    mv Package $out/Applications
    ln -s "$out/Applications/EasyRPG Player.app/Contents/MacOS/EasyRPG Player" $out/bin/easyrpg-player
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  enableParallelChecking = true;

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { attrPath = "liblcf"; })
    (nix-update-script { })
  ];

  meta = {
    description = "RPG Maker 2000/2003 and EasyRPG games interpreter";
    homepage = "https://easyrpg.org/";
    changelog = "https://github.com/EasyRPG/Player/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.all;
    mainProgram = "easyrpg-player";
  };
})
