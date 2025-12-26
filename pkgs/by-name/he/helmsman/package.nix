{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "helmsman";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "mkubaczyk";
    repo = "helmsman";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-URIJLt2LshtNwZ7xA/YAtYovL5FQJIIBs//P3JHSpA4=";
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
