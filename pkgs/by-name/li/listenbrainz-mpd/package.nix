{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  stdenv,
  openssl,
  libiconv,
  sqlite,
  installShellFiles,
  asciidoctor,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "listenbrainz-mpd";
  version = "2.5.1";

  src = fetchFromCodeberg {
    owner = "elomatreb";
    repo = "listenbrainz-mpd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-087+l3calge6hKu3h84C98mIpW6qFAZwRMe4lkQCU4o=";
  };

  cargoHash = "sha256-SxXEathWAGqdgeJmIn5h9Zvv7Z3DGXa4htkODf/ANRQ=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    asciidoctor
  ];

  buildInputs = [
    sqlite
  ]
  ++ (
    if stdenv.hostPlatform.isDarwin then
      [
        libiconv
      ]
    else
      [
        openssl
      ]
  );

  buildFeatures = [
    "shell_completion"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "systemd"
  ];

  postInstall = ''
    installShellCompletion \
      --bash generated_completions/listenbrainz-mpd.bash \
      --fish generated_completions/listenbrainz-mpd.fish \
      --zsh generated_completions/_listenbrainz-mpd

    asciidoctor --backend=manpage listenbrainz-mpd.adoc -o listenbrainz-mpd.1
    installManPage listenbrainz-mpd.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://codeberg.org/elomatreb/listenbrainz-mpd";
    changelog = "https://codeberg.org/elomatreb/listenbrainz-mpd/src/tag/v${finalAttrs.version}/CHANGELOG.md";
    description = "ListenBrainz submission client for MPD";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      DeeUnderscore
      Kladki
    ];
    mainProgram = "listenbrainz-mpd";
  };
})
