{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  dovecot,
  xapian,
}:

stdenv.mkDerivation rec {
  pname = "dovecot-fts-flatcurve";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "slusarz";
    repo = "dovecot-fts-flatcurve";
    rev = "refs/tags/v${version}";
    hash = "sha256-96sR/pl0G0sSjh/YrXdgVgASJPhrL32xHCbBGrDxzoU=";
  };

  buildInputs = [
    xapian
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--with-moduledir=${placeholder "out"}/lib/dovecot/modules"
  ];

  meta = with lib; {
    homepage = "https://slusarz.github.io/dovecot-fts-flatcurve/";
    description = "Dovecot FTS Flatcurve plugin (Xapian)";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ euxane ];
    platforms = platforms.unix;
  };
}
