{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-ori";
  version = "0.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Reverier-Xu";
    repo = "Ori-fcitx5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wspAM/LM7v4VWWhD+Jf+IyAziUoPEXk84X2ZqxGiSoI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fcitx5/themes
    cp -r OriDark OriLight $out/share/fcitx5/themes

    runHook postInstall
  '';

  meta = {
    description = "Theme with round corners for fcitx5";
    homepage = "https://github.com/Reverier-Xu/Ori-fcitx5";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ cubewhy ];
  };
})
