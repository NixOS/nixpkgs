{
  fetchurl,
  lib,
  libxml2,
  makeWrapper,
  python3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doclifter";
  version = "2.21";

  src = fetchurl {
    url = "http://www.catb.org/~esr/doclifter/doclifter-${finalAttrs.version}.tar.gz";
    hash = "sha256-3zb+H/rRmU87LWh0+kQtiRMZ4JwJ3tVrt8vQ/EeKx8Q=";
  };

  postPatch = ''
    substituteInPlace manlifter \
      --replace-fail '/usr/bin/env python2' '/usr/bin/env python3' \
      --replace-fail 'import thread, threading, Queue' 'import _thread, threading, queue' \
      --replace-fail 'thread.get_ident' '_thread.get_ident' \
      --replace-fail 'Queue.Queue' 'queue.Queue'
  '';

  nativeBuildInputs = [
    python3
    makeWrapper
  ];

  buildInputs = [ python3 ];

  strictDeps = true;

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp manlifter $out/bin
    wrapProgram "$out/bin/manlifter" \
        --prefix PATH : "${lib.getBin libxml2}/bin:$out/bin"
    gzip < manlifter.1 > $out/share/man/man1/manlifter.1.gz
  '';

  meta = {
    changelog = "https://gitlab.com/esr/doclifter/-/blob/2.21/NEWS";
    description = "Lift documents in nroff markups to XML-DocBook";
    homepage = "http://www.catb.org/esr/doclifter";
    license = lib.licenses.bsd2;
    mainProgram = "doclifter";
    platforms = lib.platforms.unix;
  };
})
