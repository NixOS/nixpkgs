{ lib
, rustPlatform
, fetchFromGitea
, pkg-config
, stdenv
, openssl
, libiconv
, sqlite
, Security
, SystemConfiguration
, CoreFoundation
, installShellFiles
, asciidoctor }:

rustPlatform.buildRustPackage rec {
  pname = "listenbrainz-mpd";
  version = "2.3.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "elomatreb";
    repo = "listenbrainz-mpd";
    rev = "v${version}";
    hash = "sha256-QBc0avci232UIxzTKlS0pjL7cCuvwAFgw6dSwdtYAtU=";
  };

  cargoHash = "sha256-jnDS9tIJ387A2P9oUSYB3tXrXjwwVmQ26erIIlHBkao=";

  nativeBuildInputs = [ pkg-config installShellFiles asciidoctor ];

  buildInputs = [ sqlite ] ++ (if stdenv.hostPlatform.isDarwin then [
    libiconv
    Security
    SystemConfiguration
    CoreFoundation
  ] else [
    openssl
  ]);

  buildFeatures = [
    "shell_completion"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
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

  meta = with lib; {
    homepage = "https://codeberg.org/elomatreb/listenbrainz-mpd";
    changelog = "https://codeberg.org/elomatreb/listenbrainz-mpd/src/tag/v${version}/CHANGELOG.md";
    description = "ListenBrainz submission client for MPD";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ DeeUnderscore ];
    mainProgram = "listenbrainz-mpd";
  };
}
