{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "efm-langserver";
  version = "0.0.56";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-M2I5UQYCkIVfINWEVa4tOt0Dtl4sBZoHP/q0ia/Bo2Y=";
  };

  vendorHash = "sha256-3Rz/9p1moT3rQPY3/lka9HZ16T00+bAWCc950IBTkFE=";
  subPackages = [ "." ];

  meta = {
    description = "General purpose Language Server";
    mainProgram = "efm-langserver";
    maintainers = with lib.maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = lib.licenses.mit;
  };
})
