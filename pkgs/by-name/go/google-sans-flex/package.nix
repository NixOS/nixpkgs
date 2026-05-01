{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "google-sans-flex";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "he1zu";
    repo = "google-sans-flex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-r0OpOnxuYnC0ttYuzuFDobfpnkSb0dlFqvFrqKXdHTM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Google Sans Flex variable font";
    homepage = "https://fonts.google.com/specimen/Google+Sans+Flex";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ heizu ];
    platforms = lib.platforms.all;
  };
})
