<<<<<<< HEAD
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
=======
{ darwin, fetchFromGitHub, rustPlatform, lib, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "click";
  version = "0.4.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "databricks";
    repo = "click";
    sha256 = "18mpzvvww2g6y2d3m8wcfajzdshagihn59k03xvcknd5d8zxagl3";
  };

  cargoSha256 = "16r5rwdbqyb5xrjc55i30xb20crpyjc75zn10xxjkicmvrpwydp6";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = ''The "Command Line Interactive Controller for Kubernetes"'';
    homepage = "https://github.com/databricks/click";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mbode ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
<<<<<<< HEAD
    mainProgram = "click";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
