{
  fetchCrate,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flux9s";
  version = "0.10.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-a+kGFxhqeo8Na5T4IZkyhFyPqT6FvOLP3oiuJUuJIOY=";
  };

  cargoHash = "sha256-M2UCpSwKVFGXACcYkxJ8TzRHYgTLqt29RBMMdRvHZv8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "K9s-inspired terminal UI for monitoring Flux GitOps resources in real-time";
    mainProgram = "flux9s";
    homepage = "https://flux9s.ca/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
