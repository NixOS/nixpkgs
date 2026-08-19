{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libgit2,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pullomatic";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "fooker";
    repo = "pullomatic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qPuJ2mqbqQQxncsz5DexOYyNctIInX0Of5mdAGu/t/M=";
  };

  cargoHash = "sha256-+B/DzDaF3qQlPzjh97CBMAseyeUClgsgzE0EJ8kTlqg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    libgit2
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automates Git repository syncing through pure configuration";
    homepage = "https://github.com/fooker/pullomatic";
    license = lib.licenses.mit;
    mainProgram = "pullomatic";
    maintainers = with lib.maintainers; [ fooker ];
  };
})
