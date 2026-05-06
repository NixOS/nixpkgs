{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation rec {
  pname = "amiri";
  version = "1.003";

  src = fetchzip {
    url = "https://github.com/aliftype/amiri/releases/download/${version}/Amiri-${version}.zip";
    hash = "sha256-BsYPMBlRdzlkvyleZIxGDuGjmqhDlEJ4udj8zoKUSzA=";
  };

  nativeBuildInputs = [ installFonts ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/doc/${pname}-${version}
    mv {*.html,*.txt,*.md} $out/share/doc/${pname}-${version}/

    runHook postInstall
  '';

  meta = {
    description = "Classical Arabic typeface in Naskh style";
    homepage = "https://www.amirifont.org/";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.vbgl ];
    platforms = lib.platforms.all;
  };
}
