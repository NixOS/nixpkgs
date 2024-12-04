{ lib, stdenvNoCC, fetchFromGitHub, nix-update-script }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "material-icons";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = finalAttrs.version;
    hash = "sha256-wX7UejIYUxXOnrH2WZYku9ljv4ZAlvgk8EEJJHOCCjE=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp font/*.ttf $out/share/fonts/truetype

    mkdir -p $out/share/fonts/opentype
    cp font/*.otf $out/share/fonts/opentype

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "System status icons by Google, featuring material design";
    homepage = "https://material.io/icons";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ mpcsh ];
  };
})
