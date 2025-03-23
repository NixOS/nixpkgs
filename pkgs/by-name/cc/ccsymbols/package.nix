{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ccsymbols";
  version = "2020-04-19";

  src = fetchurl {
    url = "https://www.ctrl.blog/file/${version}_cc-symbols.zip";
    hash = "sha256-hkARhb8T6VgGAybYkVuPuebjhuk1dwiBJ1bZMwvYpMY=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    install -Dm644 CCSymbols.* -t $out/share/fonts/ccsymbols

    runHook postInstall
  '';

  passthru = { inherit pname version; };

  meta = with lib; {
    description = "Creative Commons symbol font";
    homepage = "https://www.ctrl.blog/entry/creative-commons-unicode-fallback-font.html";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
