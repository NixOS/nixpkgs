{ lib, stdenvNoCC, fetchFromGitHub, rename, nix-update-script }:

stdenvNoCC.mkDerivation {
  pname = "cinzel";
  version = "0-unstable-2020-07-22";

  src = fetchFromGitHub {
    owner = "NDISCOVER";
    repo = "Cinzel";
    rev = "dd598495b0fb2ad84270d5cc75d642d2f1e8eabf";
    hash = "sha256-V3vSxe5eHN0BUplzmmBchzuV+gz36WfgZZezJ6NfaWg=";
  };

  outputs = [ "out" "variable" ];

  nativeBuildInputs = [ rename ];

  installPhase = ''
    runHook preInstall

    rename 's/\[wght\]//g' "" fonts/variable/*
    install -Dm644 fonts/ttf/*.ttf -t $out/share/fonts/truetype
    install -Dm644 fonts/variable/*.ttf -t $variable/share/fonts/truetype

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/NDISCOVER/Cinzel";
    description = "Typeface inspired in First Century Roman Inscriptions";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.marijanp ];
  };
}
