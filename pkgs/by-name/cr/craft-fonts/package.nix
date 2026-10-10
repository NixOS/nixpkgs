{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "craft-fonts";
  version = "0.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-fonts";
    rev = "8dcdacd5153e64560d109541a47d806f26f048c0";
    hash = "sha256-4E9OrthE5z39xFXpvpwn4Fn6RH3wX2sF56rZZejZT+I=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r fonts $out/fonts

    install -d $out/share/doc/craft-fonts
    install -m644 ATTRIBUTION.md README.md LICENSE-MIT LICENSE-APACHE \
      $out/share/doc/craft-fonts/

    runHook postInstall
  '';

  meta = {
    description = "Shared font bundle for the ArtCraft application suite";
    homepage = "https://github.com/storytold/craft-fonts";
    license = lib.licenses.OR [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    maintainers = with lib.maintainers; [
      cleboost
      gaelj
    ];
    platforms = lib.platforms.all;
  };
}
