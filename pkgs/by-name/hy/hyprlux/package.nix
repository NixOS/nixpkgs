{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyprlux";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "amadejkastelic";
    repo = "Hyprlux";
    tag = finalAttrs.version;
    hash = "sha256-9BDMqnvm5w1W7Tsuu8ixCpc8oVECe1twXwIw+z5HRdM=";
  };

  cargoHash = "sha256-A2LMCtgtMYjnUE3vhC4EqJpcuJSz1DBXbt5BCvhlU14=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyprland utility that automates vibrance and night light control";
    homepage = "https://github.com/amadejkastelic/Hyprlux";
    changelog = "https://github.com/amadejkastelic/Hyprlux/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.amadejkastelic ];
    mainProgram = "hyprlux";
  };
})
