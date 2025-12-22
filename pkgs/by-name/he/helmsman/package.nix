{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "helmsman";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "mkubaczyk";
    repo = "helmsman";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-gaX9Pa5p/zqKLfEUVTKd3tIYX5DkndyVmuZBG5rT4qs=";
  };

  subPackages = [ "cmd/helmsman" ];

  vendorHash = "sha256-ToSZQ5sv7z7O8tyDFmEY+KWzAAvv8MXvacoem5K+0Fg=";

  doCheck = false;

  meta = {
    description = "Helm Charts (k8s applications) as Code tool";
    mainProgram = "helmsman";
    homepage = "https://github.com/Praqma/helmsman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lynty
      sarcasticadmin
    ];
  };
})
