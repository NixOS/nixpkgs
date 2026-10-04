{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage {
  pname = "fcast-client";
  version = "0.1.0-unstable-2026-06-02";

  src = fetchFromGitLab {
    domain = "gitlab.futo.org";
    owner = "videostreaming";
    repo = "fcast";
    rev = "cb3dc29d31b2b97277b1b96b0267c3d61922a4d2";
    hash = "sha256-ipnch1QU//EspAuWRh+s4hQAIwfkJDFjibPY4bCW0k0=";
  };

  # `fcast` is one member of a large Cargo workspace; the other members (GUI
  # senders and receivers) pull git dependencies (slint, gst-plugins-rs) that the
  # terminal client never uses and that cannot be vendored here. Trim the
  # workspace to the client's dependency closure so the build resolves against the
  # small, git-free Cargo.lock committed alongside this package.
  postPatch = ''
    sed -i '/^members = \[/,/^]/c\members = [ "senders/terminal", "sdk/sender/fcast-sender-sdk", "crates/fcast-protocol", "crates/file-server", "crates/google-cast-protocol" ]' Cargo.toml
    cp ${./Cargo.lock} Cargo.lock
    rm -f senders/terminal/Cargo.lock
  '';

  cargoLock.lockFile = ./Cargo.lock;

  buildAndTestSubdir = "senders/terminal";

  meta = {
    description = "FCast Client Terminal, a terminal open-source media streaming client";
    homepage = "https://fcast.org/";
    license = lib.licenses.gpl3;
    longDescription = ''
      FCast is a protocol designed for wireless streaming of audio and video
      content between devices. Unlike alternative protocols like Chromecast and
      AirPlay, FCast is an open source protocol that allows for custom receiver
      implementations, enabling third-party developers to create their own
      receiver devices or integrate the FCast protocol into their own apps.
    '';
    mainProgram = "fcast";
    maintainers = with lib.maintainers; [
      caniko
      yusufraji
    ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
