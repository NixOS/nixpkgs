{ darwin, fetchFromGitHub, rustPlatform, lib, stdenv, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "click";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "click";
    rev = "v${version}";
    hash = "sha256-rwS08miRpc+Q9DRuspr21NMYpEYmmscvzarDnjyVe5c=";
  };

  cargoHash = "sha256-WNITVYTS7JWrBBwxlQuVTmLddWLbDJACizEsRiustGg=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = ''The "Command Line Interactive Controller for Kubernetes"'';
    homepage = "https://github.com/databricks/click";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mbode ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    mainProgram = "click";
  };
}
