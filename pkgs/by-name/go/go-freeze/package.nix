{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "go-freeze";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "freeze";
    rev = "80921ba68140be487382d91b40545ce9044a31b8";
    hash = "sha256-1zc62m1uS8Bl6x54SG2///PWfiKbZood6VBibbsFX7I=";
  };

  vendorHash = "sha256-BEMVjPexJ3Y4ScXURu7lbbmrrehc6B09kfr03b/SPg8=";

  installHook = ''
    ## Avoid conflicting with `pkgs.freeze`
    mv $out/bin/{freeze,go-freeze}
  '';

  meta = {
    homepage = "https://github.com/charmbracelet/freeze";
    description = "Generate images of code and terminal output";
    license = lib.licenses.mit;
    changelog = "https://github.com/charmbracelet/freeze/releases/tag/v${finalAttrs.version}";
    mainProgram = finalAttrs.pname;
    maintainers = with lib.maintainers; [ S0AndS0 ];
  };
})
