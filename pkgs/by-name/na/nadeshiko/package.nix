{
  lib,
  stdenvNoCC,
  fetchFromGitea,
  makeBinaryWrapper,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  bash,
  bc,
  coreutils,
  ffmpeg,
  file,
  findutils,
  fontconfig,
  gnugrep,
  gnused,
  inotify-tools,
  jq,
  libnotify,
  lsof,
  mediainfo,
  mpv,
  ncurses,
  perlPackages,
  procps,
  psmisc,
  python3,
  shared-mime-info,
  socat,
  time,
  util-linuxMinimal,
  which,
  xmlstarlet,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nadeshiko";
  version = "2.33.5";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "deterenkelt";
    repo = "Nadeshiko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5VVZSfub/o7PfDgumaR2lV9AYyonO7oNRPagc3M2pIs=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    substituteInPlace \
      nadeshiko.sh nadeshiko-mpv.sh nadeshiko-do-postponed.sh lazily_archive_video.sh \
      --replace-fail \
      '"$mypath/lib/bahelite/bahelite.sh"' \
      '"${placeholder "out"}/lib/nadeshiko/bahelite/bahelite.sh"'

    substituteInPlace \
      lib/bahelite/modules/core/bootstrap/load_modules.sh \
      --replace-fail '/bin/ls' '${lib.getExe' coreutils "ls"}'

    # Postponed job files embed this command and may be run standalone, so
    # they call the wrapper instead of the unwrapped script.
    substituteInPlace \
      modules/nadeshiko-mpv/03_choose_preset.sh \
      modules/nadeshiko-mpv/04_encoding.sh \
      --replace-fail '"$MYDIR/nadeshiko.sh"' '"${placeholder "out"}/bin/nadeshiko.sh"'

    # Files in the store are read-only, so copies of them must not keep that
    # mode.  The dialogues rewrite their copies in TMPDIR, and the crop tool
    # copies its script there again each time a crop is picked.
    substituteInPlace \
      modules/nadeshiko-mpv/dialogues_gtk.sh \
      modules/nadeshiko-do-postponed/dialogues_gtk.sh \
      --replace-fail 'cp "$glade_file"' 'cp --no-preserve=mode "$glade_file"' \
      --replace-fail 'cp "$py_file"' 'cp --no-preserve=mode "$py_file"'

    substituteInPlace \
      modules/nadeshiko-mpv/croptool_mpv-crop-script.sh \
      --replace-fail 'cp "$orig_croptool_path"' 'cp --no-preserve=mode "$orig_croptool_path"'

    # Store files carry the epoch as their modification time, so "--update"
    # would never refresh the example configuration after an upgrade.
    substituteInPlace \
      lib/bahelite/modules/rcfile.sh \
      --replace-fail 'cp --update' 'cp --force --no-preserve=mode'
  '';

  nativeBuildInputs = [
    gobject-introspection
    makeBinaryWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    bash
    gtk3
  ];

  runtimeDeps = [
    bash
    bc
    coreutils
    ffmpeg
    file
    findutils
    fontconfig
    gnugrep
    gnused
    inotify-tools
    jq
    libnotify
    lsof
    mediainfo
    mpv
    ncurses
    perlPackages.FileMimeInfo
    procps
    psmisc
    (python3.withPackages (ps: [ ps.pygobject3 ]))
    socat
    time
    util-linuxMinimal
    which
    xmlstarlet
  ];

  postInstall = ''
    mkdir -p $out/libexec/nadeshiko
    mv $out/bin/*.sh $out/libexec/nadeshiko
    rm $out/bin/*
  '';

  dontWrapGApps = true;

  # Bahelite only searches its source directories next to the script or
  # under /usr, so the wrappers point it at the installed directories.  They
  # run the scripts as "bash <script>", which is the command line that the
  # single process check of Bahelite expects to find with pgrep.
  postFixup = ''
    wrap() {
      makeBinaryWrapper ${lib.getExe bash} $out/bin/$2 \
        --argv0 bash \
        --add-flags $out/libexec/nadeshiko/$1.sh \
        "''${gappsWrapperArgs[@]}" \
        --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps} \
        --prefix XDG_DATA_DIRS : ${shared-mime-info}/share \
        --set MODULESDIR $out/lib/nadeshiko \
        --set LIBDIR $out/lib/nadeshiko \
        --set METACONFDIR $out/share/nadeshiko/metaconf \
        --set DEFCONFDIR $out/share/nadeshiko/defconf \
        --set RESDIR $out/share/nadeshiko/res
      ln -s $2 $out/bin/$1.sh
    }

    wrap nadeshiko nadeshiko
    wrap nadeshiko-mpv nadeshiko-mpv
    wrap nadeshiko-do-postponed nadeshiko-do-postponed
    wrap lazily_archive_video lae
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cut short videos with ffmpeg";
    homepage = "https://codeberg.org/deterenkelt/Nadeshiko";
    changelog = "https://codeberg.org/deterenkelt/Nadeshiko/src/tag/v${finalAttrs.version}/RELEASE_NOTES";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "nadeshiko";
    platforms = lib.platforms.linux;
  };
})
