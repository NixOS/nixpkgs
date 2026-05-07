{
  lib,
  stdenv,
  fetchFromGitHub,
  expat,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newflasher";
  version = "59";

  src = fetchFromGitHub {
    owner = "munjeni";
    repo = "newflasher";
    tag = "${finalAttrs.version}";
    hash = "sha256-ulcHbSoMXnu0pauYUaZiTVvl5VtEYnYy3ljtZ0oEvGM=";
  };

  buildInputs = [
    expat
    zlib
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 newflasher $out/bin/newflasher
    runHook postInstall
  '';

  meta = {
    description = "Flash tool for new Sony flash tool protocol (Xperia XZ Premium and newer)";
    homepage = "https://github.com/munjeni/newflasher";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
