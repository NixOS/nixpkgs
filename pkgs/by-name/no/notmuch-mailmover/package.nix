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
rustPlatform.buildRustPackage rec {
  pname = "notmuch-mailmover";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "michaeladler";
    repo = "notmuch-mailmover";
    rev = "v${version}";
    hash = "sha256-xX1sH+8DaLgCzkl5WwwNEE9+iTdZX0d64SxfmvuVVgs=";
  };

  cargoHash = "sha256-5jEM5FURnfuoOiu2rqsh4shMp1ajv0zMpIx7r0gv6Bc=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    notmuch
    lua5_4
  ];

  postInstall = ''
    installManPage share/notmuch-mailmover.1.gz

    mkdir -p $out/share/notmuch-mailmover
    cp -dR example $out/share/notmuch-mailmover/

    installShellCompletion --cmd notmuch-mailmover \
      --bash share/notmuch-mailmover.bash \
      --fish share/notmuch-mailmover.fish \
      --zsh share/_notmuch-mailmover
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Application to assign notmuch tagged mails to IMAP folders";
    mainProgram = "notmuch-mailmover";
    homepage = "https://github.com/michaeladler/notmuch-mailmover/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      michaeladler
      archer-65
    ];
    platforms = platforms.all;
  };
}
