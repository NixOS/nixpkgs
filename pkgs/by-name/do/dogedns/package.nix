{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, pkg-config
, openssl
, pandoc
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dogedns";
  version = "0.2.8-beta";

  src = fetchFromGitHub {
    owner = "Dj-Codeman";
    repo = "doge";
    rev = "v${version}";
    hash = "sha256-EF/090/wWgFt6+V8xDmbAWd+jpHhx0mlGYtQqo8YsEI=";
  };

  cargoHash = "sha256-V7QoLSwhu+Nq7a4V0i57VityfhkVabkojxpjwW/wpsc=";

  patches = [
    # remove date info to make the build reproducible
    # remove commit hash to avoid dependency on git and the need to keep `.git`
    ./remove-date-info.patch
  ];

  nativeBuildInputs = [ installShellFiles pandoc ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

 postInstall = ''
    installShellCompletion completions/doge.{bash,fish,zsh}
    installManPage ./target/man/*.1
  '';

  meta = with lib; {
    description = "Reviving a command-line DNS client";
    homepage = "https://github.com/Dj-Codeman/doge";
    license = licenses.eupl12;
    mainProgram = "doge";
    maintainers = with maintainers; [ aktaboot ];
  };
}
