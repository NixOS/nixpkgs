{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
let
  version = "1.3.0";
in
rustPlatform.buildRustPackage {
  pname = "markuplinkchecker";
  inherit version;

  src = fetchFromGitHub {
    owner = "becheran";
    repo = "mlc";
    rev = "v${version}";
    hash = "sha256-mAE4wpR8pY2ZdfpXy9flM+WiyJim/X458xyxwBUmPtI=";
  };

  cargoHash = "sha256-YjYGfSPGdB7A9tO1zH157spq38J0XiTAajDK/Xa5Bow=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  doCheck = false; # tests require an internet connection

  meta = {
    description = "Check for broken links in markup files";
    homepage = "https://github.com/becheran/mlc";
    changelog = "https://github.com/becheran/mlc/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anas
    ];
    mainProgram = "mlc";
  };
}
