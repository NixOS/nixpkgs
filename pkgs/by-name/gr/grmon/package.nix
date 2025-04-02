{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "grmon";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = "grmon";
    rev = "v${version}";
    hash = "sha256-0J7f4DMADUut3Da0F1eTDsT1Hlk0rfInwzbcVcQNzg8=";
  };

  vendorHash = "sha256-ySgWEGHlEJpfB/BZuRs1bELBspEaiaX/UnJai2V/hx0=";

  CGO_ENABLED = "0";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Command line monitoring for goroutines";
    longDescription = ''
      To use it, instrument your Go code following the
      [usage description of the project](https://github.com/bcicen/grmon?tab=readme-ov-file#usage).
    '';
    homepage = "https://github.com/bcicen/grmon";
    license = licenses.mit;
    mainProgram = "grmon";
    maintainers = with maintainers; [ katexochen ];
  };
}
