{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  installShellFiles,
  ladybugdb,
  nix-update-script,
  openssl,

  buildPackages,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rudof";
  version = "0.3.21";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rudof-project";
    repo = "rudof";
    tag = finalAttrs.version;
    hash = "sha256-WYDF6PiPasGRa0XT9P/UBAhg0c1L9CIJYKSubl1bbj8=";
  };

  cargoHash = "sha256-EiXHCeM2z24ygwwhYwFAwO9VcFuhryG2FaVnOZ4Pv1U=";

  buildFeatures = [
    "qlever"
  ];

  buildInputs = [
    openssl
  ];

  cargoBuildFlags = [
    "--config"
    "profile.release.lto=true"
    "--config"
    "profile.release.strip=true"
  ];

  nativeBuildInputs = [
    installShellFiles
    # Needed for rustemo-compiler crate
    git
  ];

  # Needed for lbug crate
  env = {
    LBUG_INCLUDE_DIR = "${ladybugdb.dev}/include";
    LBUG_LIBRARY_DIR = "${ladybugdb.lib}/lib";
  };

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}"
        else
          lib.getExe buildPackages.rudof;
    in
    ''
      installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --nushell <(${exe} completion nushell) \
        --zsh <(${exe} completion zsh)
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "RDF and Knowledge Graphs processing tool";
    homepage = "https://rudof-project.github.io/";
    changelog = "https://github.com/rudof-project/rudof/releases/tag/${finalAttrs.version}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.tensor5 ];
    mainProgram = "rudof";
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "aarch64-linux"
    ];
  };
})
