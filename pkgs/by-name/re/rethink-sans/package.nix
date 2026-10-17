{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "rethink-sans";
  version = "0-unstable-2023-10-11";

  src = fetchFromGitHub {
    owner = "hans-thiessen";
    repo = "Rethink-Sans";
    rev = "20d5980cd14ce827e82d7fc58d758f7cc5086c91";
    hash = "sha256-qoiruy6cSE4Aew3fboYv1lOHDjuFoTMzJqT3xhRkXB8=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 fonts/variable/*.ttf fonts/ttf/*.ttf -t $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = {
    description = "Humble open source font built on the shoulders of DM Sans and Poppins";
    homepage = "https://github.com/hans-thiessen/Rethink-Sans";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.all;
  };
}
