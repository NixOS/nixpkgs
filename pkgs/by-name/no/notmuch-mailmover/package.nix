{
  notmuch,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  lua5_4,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "notmuch-mailmover";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "michaeladler";
    repo = "notmuch-mailmover";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HbWiWoCVyYW2tgu0V3ysB27oUQx2EQNQUPg6ZjA3QjQ=";
  };

  cargoHash = "sha256-E3t7aWatRIc7pjLX6T8L8sNloz5H0qsTBOpKPvXbwEo=";

  env.RUST_LOG = "info"; # needed for integration tests

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    notmuch
    lua5_4
  ];

  nativeCheckInputs = [
    notmuch
  ];

  postInstall = ''
    installManPage share/notmuch-mailmover.1

    mkdir -p $out/share/notmuch-mailmover
    cp -dR example $out/share/notmuch-mailmover/

    installShellCompletion --cmd notmuch-mailmover \
      --bash share/notmuch-mailmover.bash \
      --fish share/notmuch-mailmover.fish \
      --zsh share/_notmuch-mailmover
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Application to assign notmuch tagged mails to IMAP folders";
    mainProgram = "notmuch-mailmover";
    homepage = "https://github.com/michaeladler/notmuch-mailmover/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      michaeladler
      archer-65
    ];
    platforms = lib.platforms.all;
  };
})
