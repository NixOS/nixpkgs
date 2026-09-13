{
  lib,
  fetchFromGitHub,
  buildNavidromeRustPlugin,
}:

buildNavidromeRustPlugin rec {
  pname = "lyrics-plugin";
  bundleName = "nd-lyrics";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "J0R6IT0";
    repo = "navidrome-lyrics-plugin";
    tag = "v${version}";
    hash = "sha256-Psix1p4ykF2f6A/AUwL8yysQRN7u41xCkjGQIM1h1K4=";
  };

  cargoHash = "sha256-fGgoh5t/cfX59iGtcgIHMHBpIqkseW73XdJM2Qnezp0=";

  meta = {
    description = "Fetches lyrics from various sources";
    homepage = "https://github.com/J0R6IT0/navidrome-lyrics-plugin";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
