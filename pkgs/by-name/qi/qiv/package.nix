{
  lib,
  stdenv,
  fetchFromCodeberg,
  pkg-config,
  gtk3,
  file,
  lcms2,
  libexif,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qiv";
  version = "3.0.4";

  src = fetchFromCodeberg {
    owner = "ciberandy";
    repo = "qiv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5VnId+2RbtS1Aq036X2bby+R2SemqgoDBdEnWhXs2Qo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3
    file
    lcms2
    libexif
  ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace-fail /usr/local "$out" \
      --replace-fail /man/ /share/man/ \
      --replace-fail /share/share/ /share/
  '';

  meta = {
    description = "Quick image viewer";
    homepage = "http://spiegl.de/qiv/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "qiv";
  };
})
