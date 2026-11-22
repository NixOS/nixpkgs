{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_image,
  alsa-lib,
  autoconf-archive,
  autoreconfHook,
  bison,
  fetchpatch2,
  fetchzip,
  flex,
  fluidsynth,
  freepats,
  freetype,
  gdk-pixbuf,
  gtk3,
  icu,
  libmt32emu,
  libogg,
  libpng,
  libvorbis,
  libx11,
  nix-update-script,
  pkg-config,
  soundfont-fluid,
  versionCheckHook,
  wrapGAppsHook3,
  zlib,
  enableStudio ? true,
  enableTools ? true,
  withAudioPack ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exult";
  version = "1.12.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "exult";
    repo = "exult";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rAUg8RoPsou1g27MZ84vFc0uDvUGzLXkGj33Vbsjlr8=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  patches = [
    ./bundled-mods.patch
    ./game-data-in-home.patch
    (fetchpatch2 {
      name = "metainfo-add-1.12-releases.patch";
      url = "https://github.com/exult/exult/commit/6baa6d252fdbc9212b09e59b95c4838b7e3e63c3.patch?full_index=1";
      hash = "sha256-424sACGG8rZpBZjtBvINZwEwG2w3FpcyJDi0Qy3zWrQ=";
      includes = [ "desktop/*.metainfo.xml" ];
    })
    # https://github.com/exult/exult/commit/f3fcdb521bcf5531256abf07538b50fc2d33a425
    (fetchpatch2 {
      name = "mockup-palette-size.patch";
      url = "https://github.com/exult/exult/commit/f3fcdb521bcf5531256abf07538b50fc2d33a425.patch?full_index=1";
      hash = "sha256-6UBIXif8T+8bHy1PLz7rMQBI56BrT8g7rHUqPHaa3UU=";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace macosx/macosx.am \
      --replace-fail '$(DESTDIR)/Applications/' "$out/Applications/"
  '';

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals enableTools [
    bison
    flex
  ]
  ++ lib.optionals enableStudio [ wrapGAppsHook3 ];

  buildInputs = [
    SDL2
    fluidsynth
    libmt32emu
    libogg
    libpng
    libvorbis
    libx11
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
  ++ lib.optionals enableTools [
    SDL2_image
    gdk-pixbuf
  ]
  ++ lib.optionals enableStudio [
    freetype
    gtk3
    icu
  ];

  configureFlags = [
    (lib.enableFeature enableTools "tools")
    (lib.enableFeature enableTools "compiler")
    (lib.enableFeature enableTools "mods")
    (lib.enableFeature enableStudio "exult-studio")
    (lib.enableFeature enableStudio "exult-studio-support")
    "--enable-midi-sfx"
  ]
  ++ lib.optionals enableTools [ "--enable-shp-thumbnailer=ingame" ];

  doCheck = enableTools;
  preCheck = ''
    export SDL_VIDEODRIVER=dummy
  '';

  postInstall = ''
    ln -s ${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2 $out/share/exult/default.sf2
    cat > $out/share/exult/timidity.cfg <<EOF
    dir ${freepats}
    source ${freepats}/freepats.cfg
    EOF
  ''
  + lib.optionalString withAudioPack ''
    install -Dm644 -t $out/share/exult ${finalAttrs.passthru.audioPack}/*.flx
    install -Dm644 -t $out/share/exult/music ${finalAttrs.passthru.audioPack}/music/*.ogg
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postFixup = lib.optionalString enableStudio ''
    wrapGApp $out/bin/exult_studio
  '';

  # only exult_studio uses GTK
  dontWrapGApps = true;
  enableParallelBuilding = true;

  passthru = {
    audioPack = fetchzip {
      url = "mirror://sourceforge/exult/exult-data/exult_audio.zip";
      hash = "sha256-MIbY+6WPpFEvSGQwIX1zzfCy1nI70Ww/ho44oZebXgA=";
      stripRoot = false;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "Recreation of Ultima VII for modern operating systems";
    longDescription = ''
      Ultima VII, an RPG from the early 1990's, still has a huge following. But,
      being a DOS game with a very nonstandard memory manager, it is difficult
      to run it on the latest computers. Exult is a project that created an
      Ultima VII game engine that runs on modern operating systems, capable of
      using the data and graphics files that come with the game. Exult aims to
      let those people who own Ultima VII play the game on modern hardware, in
      as close to (or perhaps even surpassing) its original splendor as is
      possible.
    '';
    homepage = "https://exult.info";
    changelog = "https://github.com/exult/exult/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.unix;
    mainProgram = "exult";
  };
})
