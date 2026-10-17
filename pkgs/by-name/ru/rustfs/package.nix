{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  nodejs,
  rustPlatform,
  protobuf,
  cacert,
  nix-update,
  nixosTests,
  writeShellApplication,
}:

let
  pnpm = pnpm_11;

  console = stdenv.mkDerivation (finalAttrs: {
    pname = "rustfs-console";
    version = "0.1.36";
    __structuredAttrs = true;
    __darwinAllowLocalNetworking = true;

    src = fetchFromGitHub {
      owner = "rustfs";
      repo = "console";
      tag = "v${finalAttrs.version}";
      hash = "sha256-Xb29Rgz+WoD6bc1QgaRVs8x6/LYT4gaYftdnUuFbHVI=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm;
      fetcherVersion = 4;
      hash = "sha256-tWeemxHBvWEWKECIAYzlw0MaKpkjXTTodj9Rgf8U28s=";
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
  version = "1.0.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "rustfs";
    tag = finalAttrs.version;
    hash = "sha256-JXqC7Zuz7O8WSU6jstbucPo3qUUq9Srq3wBYOEWR/T0=";
  };

  postPatch = ''
    rm -rf ./rustfs/static
    cp -rL ${finalAttrs.console} ./rustfs/static
  '';

  cargoHash = "sha256-bDpk2Noge2rXTOjBSDEZFFn6yFFmm8kBzmjrBC5qIeA=";

  nativeBuildInputs = [
    protobuf
    cacert
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
