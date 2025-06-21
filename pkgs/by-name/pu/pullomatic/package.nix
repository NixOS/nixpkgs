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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "fooker";
    repo = "pullomatic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S4Qvsj8dn719KMXgRwPrOjqv5XMmH7HsNMeCc91t93o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8/NhbvCbvDrvf9uVHwtca6xpTnhOYA11CBg11d9xW5E=";

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
