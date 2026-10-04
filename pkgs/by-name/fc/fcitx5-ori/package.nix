{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-ori";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "Reverier-Xu";
    repo = "Ori-fcitx5";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wspAM/LM7v4VWWhD+Jf+IyAziUoPEXk84X2ZqxGiSoI=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r OriDark OriLight $out/share/fcitx5/themes

    runHook postInstall
  '';

  meta = {
    description = "A simple theme with round corners for fcitx5.";
    homepage = "https://github.com/Reverier-Xu/Ori-fcitx5";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ cubewhy ];
  };
})
