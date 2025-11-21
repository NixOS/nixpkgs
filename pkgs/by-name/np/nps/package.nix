{
  lib,
  nix,
  nix-update-script,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "nps";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "OleMussmann";
    repo = "nps";
    tag = "v${version}";
    hash = "sha256-kOVpn13lJYeO/99e39c0wbe7qcKHyMj5v4prBtZ3N7s=";
  };

  cargoHash = "sha256-dJA9fOU06txPAx5kMl7aGoFeKo7UXqB7X+viUfJqG/M=";

  nativeCheckInputs = [ nix ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cache the nix package list, query and sort results by relevance";
    longDescription = ''
      Find SEARCH_TERM in available nix packages and sort results by relevance.

      List up to three columns, the latter two being optional:
      PACKAGE_NAME  <PACKAGE_VERSION>  <PACKAGE_DESCRIPTION>

      Matches are sorted by type. Show 'indirect' matches first, then 'direct' matches, and finally 'exact' matches.

        indirect  fooSEARCH_TERMbar (SEARCH_TERM appears in any column)
        direct    SEARCH_TERMbar (PACKAGE_NAME starts with SEARCH_TERM)
        exact     SEARCH_TERM (PACKAGE_NAME is exactly SEARCH_TERM)
    '';
    changelog = "https://github.com/OleMussmann/nps/releases/tag/v${version}";
    homepage = "https://github.com/OleMussmann/nps";
    license = lib.licenses.mit;
    mainProgram = "nps";
    maintainers = with lib.maintainers; [
      mdaniels5757
      olemussmann
    ];
    platforms = lib.platforms.all;
  };
}
