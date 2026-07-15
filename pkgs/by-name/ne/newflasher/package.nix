{
  lib,
  stdenv,
  fetchFromGitHub,
  expat,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newflasher";
  version = "60";

  src = fetchFromGitHub {
    owner = "munjeni";
    repo = "newflasher";
    tag = "${finalAttrs.version}";
    hash = "sha256-YmFY0WPT92f5zN10TEfuRv2mzhEweqeZEpzWCK4otYg=";
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
