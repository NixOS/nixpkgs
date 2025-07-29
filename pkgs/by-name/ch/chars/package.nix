{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "chars";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "antifuchs";
    repo = "chars";
    rev = "v${version}";
    sha256 = "sha256-mBtwdPzIc6RgEFTyReStFlhS4UhhRWjBTKT6gD3tzpQ=";
  };

  cargoHash = "sha256-Df+twOjzfq+Vxzuv+APiy94XmhBajgk+6+1BRFf+xm0=";

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = with lib; {
    description = "Commandline tool to display information about unicode characters";
    mainProgram = "chars";
    homepage = "https://github.com/antifuchs/chars";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
