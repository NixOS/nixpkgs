{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
let
  pname = "git-upstream";
  version = "1.6.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "git-upstream";
    tag = "v${version}";
    hash = "sha256-rdxpo1OZD/fpBm76zD7U/YeZOBpliKXJN87LJkw6A28=";
  };

  cargoHash = "sha256-7h0aWb7xJjDJedQp9xXc+deW0hM+qBJcG36Sd8fo+Fg=";

  meta = {
    homepage = "https://github.com/9999years/git-upstream";
    changelog = "https://github.com/9999years/git-upstream/releases/tag/v${version}";
    description = "Shortcut for `git push --set-upstream`";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers._9999years ];
    mainProgram = "git-upstream";
  };

  passthru.updateScript = nix-update-script { };
}
