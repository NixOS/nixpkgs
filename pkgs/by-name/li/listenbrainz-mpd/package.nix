{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  stdenv,
  openssl,
  libiconv,
  sqlite,
  installShellFiles,
  asciidoctor,
}:

rustPlatform.buildRustPackage rec {
  pname = "listenbrainz-mpd";
  version = "2.3.9";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "elomatreb";
    repo = "listenbrainz-mpd";
    rev = "v${version}";
    hash = "sha256-j9MlvE2upocwC5xxroms3am6tqJX30sSw7PFNw8Ofog=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1x3F2TqNlqwfPUvLwU8ac4aEeEwpIy5gEyxRBC0Q5YM=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    asciidoctor
  ];

  buildInputs =
    [ sqlite ]
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

  buildFeatures =
    [
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

  meta = {
    homepage = "https://codeberg.org/elomatreb/listenbrainz-mpd";
    changelog = "https://codeberg.org/elomatreb/listenbrainz-mpd/src/tag/v${version}/CHANGELOG.md";
    description = "ListenBrainz submission client for MPD";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ DeeUnderscore ];
    mainProgram = "listenbrainz-mpd";
  };
}
