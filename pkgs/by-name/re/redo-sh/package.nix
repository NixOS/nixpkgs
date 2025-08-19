{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  coreutils,
}:

stdenv.mkDerivation {
  pname = "redo-sh";
  version = "4.0.6";

  src = fetchurl {
    url = "https://web.archive.org/web/20250225235353/http://news.dieweltistgarnichtso.net/bin/archives/redo-sh.tar.gz";
    hash = "sha256-pDhCnMelCXK/Pp3jPXZog7HLBTgrsCvX4LAVapYvxl8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share"
    mv man "$out/share"
    mv bin "$out"
    for p in $out/bin/*; do
      wrapProgram "$p" --prefix PATH : "$out/bin:${coreutils}/bin"
    done

    runHook postInstall
  '';

  meta = {
    description = "Redo implementation in Bourne Shell";
    homepage = "http://news.dieweltistgarnichtso.net/bin/redo-sh.html";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
