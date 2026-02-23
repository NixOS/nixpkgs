{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "paradise-gtk";
  version = "0-unstable-2022-06-13"; # No release, use commit's date

  src = fetchFromGitHub {
    owner = "paradise-theme";
    repo = "gtk";
    rev = "19afc8d54a96a2be5b5cf878ad988a0e0afba284";
    hash = "sha256-NXP2h/qXqLy9tQ+TQ+zuXFP4syywIj34k+Fts/mUqps="; # This should be fine since repo is basically abandoned
  };

  npmDepsHash = "sha256-PEXClnWZHmO3pdES6QcAGXBUhBklsdFqz1LjnFMtcs4=";

  npmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    themeDir=$out/share/themes/paradise
    mkdir -p "$themeDir"

    install -m 0644 index.theme "$themeDir"
    cp -r assets gtk-3.0 "$themeDir"

    runHook postInstall
  '';

  meta = {
    description = "Paradise GTK theme";
    homepage = "https://github.com/paradise-theme/gtk";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.asteriau ];
  };
}
