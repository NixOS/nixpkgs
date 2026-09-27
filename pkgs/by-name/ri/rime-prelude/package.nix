{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "rime-prelude";
  version = "0-unstable-2026-03-21";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "rime-prelude";
    rev = "541e03e0f36ff42318848046a3b61ac47483dca3";
    hash = "sha256-8eJc1n935KjmjvDRFksZKErt694keDeDxFRvzs++luQ=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Essential files for building up your Rime configuration";
    homepage = "https://github.com/rime/rime-prelude";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ maikotan ];
    platforms = lib.platforms.all;
  };
}
