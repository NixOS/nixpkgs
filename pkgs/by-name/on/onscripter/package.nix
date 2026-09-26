{
  lib,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_ttf,
  bzip2,
  fetchFromGitHub,
  fontconfig,
  freetype,
  libjpeg,
  libogg,
  libpng,
  libvorbis,
  lua5_1,
  runCommand,
  smpeg,
  stdenv,
}:

let
  inherit (stdenv.hostPlatform) isDarwin;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "onscripter";
  version = "20230825";

  src = fetchFromGitHub {
    owner = "ogapee";
    repo = "onscripter";
    rev = finalAttrs.version;
    hash = "sha256-XaZTtOkV+2dHmcgZ4GbyiMxRBYdwT5eHxx+r05eAmBw=";
  };

  patches = [
    # Add "install" target to Makefile
    ./add-make-install.patch
    # 1. Remove libavifile dependency, which is old and unmaintained
    # 2. Replace -llua5.1 with -llua because the former didn't work even with Lua 5.1
    ./fix-linux-build.patch
    # 1. Remove direct linker flags for macOS SDKs.
    # 2. Build with Lua
    #
    # ONScripter appears to depend on macOS SDKs only indirectly through SDL, so flags provided by
    # the sdl-config command should suffice. The existing flags also referenced the deprecated
    # QuickTime framework, resulting in a build failure.
    ./fix-darwin-build.patch
  ];

  nativeBuildInputs = [
    # Take cross compilation into account
    (
      let
        commands = [
          "${lib.getDev SDL}/bin/sdl-config"
          "${lib.getDev smpeg}/bin/smpeg-config"
        ]
        ++ lib.optionals isDarwin [
          "${lib.getDev freetype}/bin/freetype-config"
        ];
      in
      runCommand "onscripter-host-deps" { } ''
        mkdir -p $out/bin
        ln -s ${lib.escapeShellArgs commands} $out/bin
      ''
    )
  ];

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
    SDL_ttf
    bzip2
    libjpeg
    libogg
    libpng
    libvorbis
    lua5_1
    smpeg
  ]
  ++ (if isDarwin then [ freetype ] else [ fontconfig ]);

  # The build script for BSDs also fall under Makefile.Linux
  makefile = if isDarwin then "Makefile.MacOSX" else "Makefile.Linux";

  strictDeps = true;

  meta = {
    homepage = "https://ogapee.github.io/www/onscripter_en.html";
    description = "Japanese visual novel scripting engine";
    license = lib.licenses.gpl2Plus;
    mainProgram = "onscripter";
    maintainers = with lib.maintainers; [ midchildan ];
    platforms = lib.platforms.unix;
  };
})
