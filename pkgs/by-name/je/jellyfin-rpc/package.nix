{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "jellyfin-rpc";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Radiicall";
    repo = "jellyfin-rpc";
    tag = version;
    hash = "sha256-zKqP6Wt38ckqCPDS1oncmx92lZJm2oeb3bfpwVc6fUc=";
  };

  cargoHash = "sha256-k9dGz+1HGcQoDMyqmJ1hEYklfYHibo1PI5jHEe0mr+w=";

  # TODO: Re-enable when upstream bumps the version number internally
  # nativeInstallCheckInputs = [
  #   versionCheckHook
  # ];
  # doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Displays the content you're currently watching on Discord";
    homepage = "https://github.com/Radiicall/jellyfin-rpc";
    changelog = "https://github.com/Radiicall/jellyfin-rpc/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "jellyfin-rpc";
  };
}
