{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "gotestfmt";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "gotesttools";
    repo = "gotestfmt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7mLn2axlHoXau9JtLhk1zwzhxkFGHgYPo7igI+IAsP4=";
  };

  vendorHash = null;

  meta = {
    description = "Go test output for humans";
    homepage = "https://github.com/gotesttools/gotestfmt";
    changelog = "https://github.com/GoTestTools/gotestfmt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unlicense;
    maintainers = [ ];
  };
})
