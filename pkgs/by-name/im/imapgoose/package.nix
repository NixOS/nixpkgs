{
  lib,
  buildGoModule,
  fetchFromSourcehut,
}:
buildGoModule rec {
  pname = "imapgoose";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "ImapGoose";
    tag = "v${version}";
    hash = "sha256-IAjuTUzI9TRt7eg4/CqN3gKGKvpAeMbCs8kuJBV4gX0=";
  };

  vendorHash = "sha256-B+9p+WuQvARtL60CpATaKsd2Q5GFJNHPogrvlUYqdjs=";

  subPackages = [
    "cmd/imapgoose"
    "cmd/capcheck"
  ];

  postInstall = ''
    install -Dm644 imapgoose.1 -t $out/share/man/man1/
    install -Dm644 imapgoose.conf.5 -t $out/share/man/man5/
    install -Dm644 LICENCE -t $out/share/licenses/imapgoose/
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
