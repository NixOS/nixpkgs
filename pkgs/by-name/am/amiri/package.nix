{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "amiri";
  version = "1.003";

  src = fetchzip {
    url = "https://github.com/aliftype/amiri/releases/download/${finalAttrs.version}/Amiri-${finalAttrs.version}.zip";
    hash = "sha256-BsYPMBlRdzlkvyleZIxGDuGjmqhDlEJ4udj8zoKUSzA=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [ installFonts ];

  installPhase = ''
    runHook preInstall

    mkdir -p $doc/share/doc/amiri-${finalAttrs.version}
    mv {*.html,*.txt,*.md} $doc/share/doc/amiri-${finalAttrs.version}/

    runHook postInstall
  '';

  meta = {
    description = "Classical Arabic typeface in Naskh style";
    homepage = "https://www.amirifont.org/";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.vbgl ];
    platforms = lib.platforms.all;
  };
})
