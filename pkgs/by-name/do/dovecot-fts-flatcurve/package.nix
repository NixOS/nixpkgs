{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  dovecot,
  xapian,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dovecot-fts-flatcurve";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "slusarz";
    repo = "dovecot-fts-flatcurve";
    tag = "v${finalAttrs.version}";
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

  meta = {
    homepage = "https://slusarz.github.io/dovecot-fts-flatcurve/";
    description = "Dovecot FTS Flatcurve plugin (Xapian)";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ euxane ];
    platforms = lib.platforms.unix;
  };
})
