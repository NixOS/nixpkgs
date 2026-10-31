{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxidns";
  version = "1.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "svenshi";
    repo = "oxidns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AJ1ZjX++5vXbuW6ongxr11yTuBO+MQEHN5lKXT9B9UQ=";
  };

  cargoHash = "sha256-giGgqdCNY1T/8cY6V1q0BxrGb3ApIGvnzJcWEa7dUMM=";

  # Most tests need the internet
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      oxidns = nixosTests.oxidns;
    };
  };

  meta = {
    description = "A high-performance, programmable DNS engine in Rust with flexible pipeline-based routing";
    homepage = "https://github.com/svenshi/oxidns";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "oxidns";
  };
})
