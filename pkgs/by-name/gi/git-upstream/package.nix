{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}: let
  pname = "git-upstream";
  version = "1.2.0";
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "9999years";
      repo = pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-GnsqZSztDLXMO4T16nfcOKMKXap88CJzJ5nObzGwhMA=";
    };

    cargoHash = "sha256-a12C/fpeo0ZJ0MFQlKHVZER9dVrXF95YI1i8MwCTCJo=";

    meta = {
      homepage = "https://github.com/9999years/git-upstream";
      changelog = "https://github.com/9999years/git-upstream/releases/tag/v${version}";
      description = "Shortcut for `git push --set-upstream`";
      license = [lib.licenses.mit];
      maintainers = [lib.maintainers._9999years];
      mainProgram = "git-upstream";
    };

    passthru.updateScript = nix-update-script {};
  }
