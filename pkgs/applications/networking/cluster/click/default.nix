{ darwin, fetchFromGitHub, rustPlatform, lib, stdenv, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "click";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "click";
    rev = "v${version}";
    hash = "sha256-tYSbyDipZg6Qj/CWk1QVUT5AG8ncTt+5V1+ekpmsKXA=";
  };

  cargoHash = "sha256-fcJTxZX9mdF4oFl/Cn1egczRy+yhWt2zLKsdLKz6Q+s=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = ''The "Command Line Interactive Controller for Kubernetes"'';
    homepage = "https://github.com/databricks/click";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.mbode ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    mainProgram = "click";
  };
}
