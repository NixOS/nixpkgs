{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "sorted-grep";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/sgrep/sgrep-${version}.tgz";
    hash = "sha256-3F7cXrZnB38YwE1sHYm/CIGKmG+1c0QU+Pk3Y53a0T4=";
  };

  postPatch = ''
    # Its Makefile is missing compiler flags and an install step
    rm -f Makefile
  '';

  buildPhase = ''
    runHook preBuild

    ${stdenv.cc.targetPrefix}cc -Wall -O2 -o sgrep sgrep.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D sgrep "$out/bin/sgrep"

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    set +o pipefail
    $out/bin/sgrep 2>&1 | grep ^Usage:

    runHook postInstallCheck
  '';

  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://sgrep.sourceforge.net/";
    description = "Sgrep (sorted grep) searches sorted input files for lines that match a search key";
    mainProgram = "sgrep";
    longDescription = ''
      Sgrep (sorted grep) searches sorted input files for lines that match a search
      key and outputs the matching lines. When searching large files sgrep is much
      faster than traditional Unix grep, but with significant restrictions.
    '';
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ivan ];
  };
}
