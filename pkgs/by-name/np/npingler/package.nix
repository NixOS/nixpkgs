{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "npingler";
  version = "unstable-2025-08-24";

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "npingler";
    rev = "b897098be1df890b669dc734edcb10bf8fc798cb";
    hash = "sha256-mMwfonIP8fnJDNdl9ANhLmYlM8tPLtBCWNIPSRBT/D4=";
  };

  cargoHash = "sha256-VhMpgrNy0NauwBSCR+5vjod9H216HPC+rdQUIFVjnRg=";

  meta = {
    description = "Nix profile manager for use with npins";
    homepage = "https://github.com/9999years/npingler";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "npingler";
  };

  passthru.updateScript = nix-update-script { };
}
