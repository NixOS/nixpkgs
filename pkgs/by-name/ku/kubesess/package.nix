{
  lib,
  rustPlatform,
  fetchFromGitHub,
  kubectl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kubesess";
  version = "3.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Ramilito";
    repo = "kubesess";
    tag = finalAttrs.version;
    hash = "sha256-lb1fUPJjns8SXfvausGY9CChjsR6NpRSYkcOutbOt8c=";
  };

  # set_default_context & set_default_namespace tests call kubectl
  nativeBuildInputs = [ kubectl ];

  cargoHash = "sha256-DV/dniWxSbOxad+ovtHtz9l+icT93isLewqHu6MHoiQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubectl plugin managing sessions";
    homepage = "https://github.com/Ramilito/kubesess";
    changelog = "https://github.com/Ramilito/kubesess/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ i077 ];
    mainProgram = "kubesess";
  };
})
