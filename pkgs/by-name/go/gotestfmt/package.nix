{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gotestfmt";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "gotesttools";
    repo = "gotestfmt";
    rev = "v${version}";
    hash = "sha256-7mLn2axlHoXau9JtLhk1zwzhxkFGHgYPo7igI+IAsP4=";
  };

  vendorHash = null;

  meta = {
    description = "Go test output for humans";
    homepage = "https://github.com/gotesttools/gotestfmt";
    changelog = "https://github.com/GoTestTools/gotestfmt/releases/tag/v${version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ urandom ];
  };
}
