{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:
let
  version = "0.21.0";
in
rustPlatform.buildRustPackage {
  pname = "markuplinkchecker";
  inherit version;

  src = fetchFromGitHub {
    owner = "becheran";
    repo = "mlc";
    rev = "v${version}";
    hash = "sha256-16ZGYUP7h6WmwjadLHqOQClejZ35LwavFgjs9x3NYVo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-u60hjpQaF+EnWzMcM7T8UjcERF0+0ArltKcQXkEaxmc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );

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
      uncenter
      anas
    ];
    mainProgram = "mlc";
  };
}
