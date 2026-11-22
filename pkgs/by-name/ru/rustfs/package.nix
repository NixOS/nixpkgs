{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  nodejs,
  rustPlatform,
  pkg-config,
  protobuf,
  zstd,
  aws-lc,
  nix-update,
  nixosTests,
  writeShellApplication,
}:

let
  pnpm = pnpm_11;

  console = stdenv.mkDerivation (finalAttrs: {
    pname = "rustfs-console";
    version = "0.1.41";
    __structuredAttrs = true;
    __darwinAllowLocalNetworking = true;

    src = fetchFromGitHub {
      owner = "rustfs";
      repo = "console";
      tag = "v${finalAttrs.version}";
      hash = "sha256-x42ATbrIhK2dV2vI80Uiao7PFnIBcDE5l3OgkJm/dq4=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-TWEoCDz0XNCEIk7f27KHHjqFRsKthLbvcumhVVU2dIw=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
    ];

    buildPhase = ''
      pnpm run build
    '';

    installPhase = ''
      runHook preInstall
      cp -r out/. $out/
      runHook postInstall
    '';
  });
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfs";
  version = "1.0.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = finalAttrs.version;
    hash = "sha256-QggJsZgmjXs8n10rbS1UgepUJjNdJnGZx8SaeVTqtuE=";
  };

  postPatch = ''
    rm -rf ./rustfs/static
    cp -rL ${finalAttrs.console} ./rustfs/static
  '';

  cargoHash = "sha256-KFnkCQojiqVIv8K7EoSVWu8mpmDjLtl1ZJHbTVHkk98=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    zstd
    aws-lc
  ];

  inherit console;

  env.RUSTFLAGS = "--cfg tokio_unstable";

  # Only build the main rustfs binary
  cargoBuildFlags = "-p rustfs";

  # they are to intensive on the resource usage, we are just relying on nixos vm test
  doCheck = false;

  passthru = {
    tests = {
      inherit (nixosTests) rustfs;
    };

    updateScript = lib.getExe (writeShellApplication {
      name = "rustfs-update-script";
      runtimeInputs = [ nix-update ];
      text = ''
        nix-update rustfs
        nix-update rustfs.console
      '';
    });
  };

  # can take over 5 hours on 2 cores and can consume significant RAM
  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "S3-compatible high-performance object storage system supporting migration and coexistence with other S3-compatible platforms such as MinIO and Ceph";
    homepage = "https://github.com/rustfs/rustfs";
    changelog = "https://github.com/rustfs/rustfs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      marcel
      adamcstephens
    ];
    mainProgram = "rustfs";
  };
})
