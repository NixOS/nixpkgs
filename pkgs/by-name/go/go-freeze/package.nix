{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
let
  pname = "go-freeze";
  version = "0.2.2";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "freeze";
    rev = "80921ba68140be487382d91b40545ce9044a31b8";
    hash = "sha256-1zc62m1uS8Bl6x54SG2///PWfiKbZood6VBibbsFX7I=";
  };
  vendorHash = "sha256-BEMVjPexJ3Y4ScXURu7lbbmrrehc6B09kfr03b/SPg8=";

  postInstall = ''
    ## Avoid conflicting with `pkgs.freeze`
    mv $out/bin/{freeze,${pname}}
  '';

  meta = {
    homepage = "https://github.com/charmbracelet/freeze";
    description = "Generate images of code and terminal output";
    license = lib.licenses.mit;
    changelog = "https://github.com/charmbracelet/freeze/releases/tag/v${version}";
    mainProgram = pname;
    maintainers = with lib.maintainers; [ S0AndS0 ];
  };
}
