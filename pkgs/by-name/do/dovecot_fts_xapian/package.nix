{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  sqlite,
  pkg-config,
  dovecot,
  xapian,
  icu,
}:

stdenv.mkDerivation rec {
  pname = "dovecot-fts-xapian";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "grosjo";
    repo = "fts-xapian";
    rev = version;
    hash = "sha256-WKUHy9/PpaDSgZYyydCm5odo3kAb2M/50oVdLjGRQ6I=";
  };

  buildInputs = [
    xapian
    icu
    sqlite
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preConfigure = ''
    export PANDOC=false
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--with-moduledir=$(out)/lib/dovecot"
  ];

  meta = {
    homepage = "https://github.com/grosjo/fts-xapian";
    description = "Dovecot FTS plugin based on Xapian";
    changelog = "https://github.com/grosjo/fts-xapian/releases";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      julm
      symphorien
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/dovecot_fts_xapian.x86_64-darwin
  };
}
