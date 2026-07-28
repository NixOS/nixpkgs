{
  lib,
  fetchFromGitHub,
  buildNavidromeRustPlugin,
}:

buildNavidromeRustPlugin rec {
  pname = "lyrics-plugin";
  bundleName = "nd-lyrics";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "J0R6IT0";
    repo = "navidrome-lyrics-plugin";
    tag = "v${version}";
    hash = "sha256-onqiK2+A+SwWTjsbmFJyET5KZOQUcKNrbqnJCRfYers=";
  };

  cargoHash = "sha256-YkGYrxwf8q3VqPQsSMOPFOHZQh0Nzr73dyUIvcc7jLk=";

  meta = {
    description = "Fetches lyrics from various sources";
    homepage = "https://github.com/J0R6IT0/navidrome-lyrics-plugin";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
