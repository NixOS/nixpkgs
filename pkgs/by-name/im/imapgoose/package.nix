{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  installShellFiles,
}:
buildGoModule rec {
  pname = "imapgoose";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "ImapGoose";
    tag = "v${version}";
    hash = "sha256-H+6S+jAZT4jj1R8sJeLzFjyNkZqo0WlTLVfu1BH+RM4=";
  };

  vendorHash = "sha256-75dP0iB3Tu1GQfi9w+H1dgWHZh7X9FJOlsLbC3Baqjg=";

  subPackages = [
    "cmd/imapgoose"
    "cmd/capcheck"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage imapgoose.1
    installManPage imapgoose.conf.5
  '';

  meta = {
    description = "IMAP to Maildir synchronization tool";
    longDescription = ''
      ImapGoose is a daemon that continuously keeps local mailboxes in sync
      with an IMAP server. It monitors both the IMAP server and local
      filesystem, immediately synchronizing changes within seconds. Unlike
      traditional sync tools, ImapGoose is highly optimized to reduce network
      traffic by leveraging modern IMAP extensions (CONDSTORE, QRESYNC, and
      NOTIFY) to perform efficient incremental syncs. It can monitor multiple
      mailboxes per connection and automatically reconnects with exponential
      back-off when network issues occur.
    '';
    homepage = "https://git.sr.ht/~whynothugo/ImapGoose";
    changelog = "https://git.sr.ht/~whynothugo/ImapGoose/refs/v${version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    mainProgram = "imapgoose";
    maintainers = with lib.maintainers; [
      bobberb
    ];
  };
}
