{ lib
, rustPlatform
, fetchurl
, avahi
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "presswork";
  version = "0.1.0";

  # fetchurl so the hash covers the release archive directly; switching to
  # fetchFromGitHub is a mechanical follow-up if reviewers prefer it.
  src = fetchurl {
    url = "https://github.com/vindeckyy/presswork/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-dLSYJLv6LitBfuHKpglHQ8um+3/+C+cboObuOhZiEho=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ avahi ];

  # The ipptool conformance suite needs a live daemon; run unit tests only.
  checkFlags = [ "--workspace" ];

  postInstall = ''
    make install DESTDIR=$out PROFILE=release USER=lp GROUP=lp \
      SYSCONFDIR=/etc/cups SPOOLDIR=/var/spool/cups LOGDIR=/var/log/cups \
      CACHEDIR=/var/cache/cups RUNDIR=/run/cups
  '';

  meta = with lib; {
    description = "Memory-safe CUPS 2.x-compatible print spooler and IPP scheduler in Rust";
    longDescription = ''
      presswork is a drop-in replacement for the CUPS scheduler (cupsd):
      the same IPP wire protocol, config files, spool layout, and
      filter/backend contracts, implemented in Rust with unsafe code
      confined to a single audited FFI crate.
    '';
    homepage = "https://github.com/vindeckyy/presswork";
    changelog = "https://github.com/vindeckyy/presswork/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    platforms = platforms.linux;
    mainProgram = "cupsd";
    maintainers = with maintainers; [ vindeckyy ];
  };
}
