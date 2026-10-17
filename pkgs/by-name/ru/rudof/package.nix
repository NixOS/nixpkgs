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
  version = "0.3.25";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rudof-project";
    repo = "rudof";
    tag = finalAttrs.version;
    hash = "sha256-/SgGpsVVP8G0U+o9Qj2qWd2eChu75d30L7WX4Ar+Als=";
  };

  cargoHash = "sha256-gTcze9XQZF6vKkeVK35n55kqEyqLeZh/Pk1Pe4cQaf0=";

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
          "${placeholder "out"}/bin/rudof-completions"
        else
          lib.getExe' buildPackages.rudof "rudof-completions";
    in
    ''
      installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
        --bash <(${exe} bash) \
        --fish <(${exe} fish) \
        --nushell <(${exe} nushell) \
        --zsh <(${exe} zsh)

      rm "$out/bin/rudof-completions"
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
      # ladybugdb doesn't build
      # "aarch64-darwin"
      "aarch64-linux"
    ];
  };
})
