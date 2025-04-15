{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
let
  pname = "git-upstream";
  version = "1.5.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-ooqz2Xp/nljx2+zQsc/RjVbGG/5YTeggU6pB8lGK0o8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-oIrUjb+yJgDR5GYrG3hPLpXYJynR9eeX00emcrcjmZY=";

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
