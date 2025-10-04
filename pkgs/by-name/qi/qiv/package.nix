{
  lib,
  stdenv,
  fetchFromGitea,
  pkg-config,
  gtk3,
  file,
  lcms2,
  libexif,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qiv";
  version = "3.0.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ciberandy";
    repo = "qiv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U++ZyJ0cVa5x/1Me7Em1W33jAYe3Q/TfMZgPj71ZaFA=";
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
