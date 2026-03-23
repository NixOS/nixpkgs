{
  lib,
  stdenv,
  fetchFromBitbucket,
  nix-update-script,
  autoconf,
  automake,
  libtool,
  re2c,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.5.0";
  pname = "libzdb";

  src = fetchFromBitbucket {
    owner = "tildeslash";
    repo = "libzdb";
    tag = "release-${lib.replaceString "." "-" finalAttrs.version}";
    hash = "sha256-fZSTu/BGIFsbEHSB/+2SObb9myg+Iyc1IDxnpv/EEhU=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    re2c
  ];
  buildInputs = [ sqlite ];

  strictDeps = true;

  preConfigure = "sh ./bootstrap";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(\\d+)-(\\d+)-(\\d+)"
    ];
  };

  meta = {
    description = "Small, easy to use Open Source Database Connection Pool Library";
    homepage = "http://www.tildeslash.com/libzdb/";
    downloadPage = "https://bitbucket.org/tildeslash/libzdb/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ maevii ];
  };
})
