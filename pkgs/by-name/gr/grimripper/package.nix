{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  libcddb,
  cdparanoia,
  vorbis-tools,
  fdk-aac-encoder,
  lame,
  flac,
  wavpack,
  opusTools,
  enableUnfree ? false,
  monkeysAudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grimripper";
  version = "3.0.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "Salamandar";
    repo = "GrimRipper";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-FMnEvHMMjk0DPmHwkCOHgO53YMKpYa3czpJ+RlhWn3c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libcddb
  ];

  runtimeDeps =
    [
      cdparanoia
      vorbis-tools
      fdk-aac-encoder
      lame
      flac
      wavpack
      opusTools
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      vorbis-tools
    ]
    ++ lib.optionals enableUnfree [
      monkeysAudio
    ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps})
  '';

  meta = {
    description = "Graphical Audio CD ripper and encoder (fork of Asunder)";
    homepage = "https://gitlab.gnome.org/Salamandar/GrimRipper";
    license = lib.licenses.gpl2Only;
    mainProgram = "grimripper";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
