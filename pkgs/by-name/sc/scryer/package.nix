{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
  nix-update-script,
  nasm,
  cacert,
}:
let
  pname = "scryer";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "scryer-media";
    repo = "scryer";
    tag = "scryer-v${version}";
    hash = "sha256-zIz9qsH+nTgfrpE6Aikd/fVp0wfTSzKQdE6clpVejy8=";
  };

  webui = buildNpmPackage {
    pname = "scryer-webui";
    inherit version src nodejs;

    sourceRoot = "${src.name}/apps/scryer-web";

    npmDepsHash = "sha256-5vKgjayikva5RxF7C8vI+iwRHs1fXV2QG55rpL51KaA=";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out/
      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;
  __structuredAttrs = true;

  cargoHash = "sha256-82AQ90QHNpTExip9y/Lp7I1UNIYNdrnmLHTYNtObTYM=";

  nativeBuildInputs = [ nasm ];

  nativeCheckInputs = [ cacert ];

  # Upstream's own CI runs its test suite on the plain `dev` profile rather
  # than `release`, which compiles far faster and needs no LTO.
  checkType = "debug";

  checkFlags = [
    # The embedded Sigstore TUF trust root has a hardcoded expiry date that
    # has passed, so this fails regardless of the sandbox/environment.
    "--skip=plugins::catalog::tests::sigstore_trust_root_rekor_keys_parse_as_der"
    # Expects chmod/chown of a freshly created file to fully apply a setgid
    # mask, which the build sandbox's permission model doesn't allow.
    "--skip=workflow::file_importer::tests::enabled_permissions_apply_file_mask_and_created_folder_mask"
    # Hardcodes /usr/bin/env, which doesn't exist on NixOS/Nix (no FHS paths).
    "--skip=process_host::tests::execute_strips_dynamic_linker_env_and_forces_clean_path"
  ];

  env.SCRYER_EMBED_UI_DIR = webui;

  passthru = {
    inherit webui;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hosted media management application for movies, TV series, and anime";
    homepage = "https://www.scryer.media";
    changelog = "https://github.com/scryer-media/scryer/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jagu-sayan ];
    mainProgram = "scryer";
  };
}
