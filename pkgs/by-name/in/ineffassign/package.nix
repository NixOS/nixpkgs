{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "ineffassign";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gordonklaus";
    repo = "ineffassign";
    rev = "refs/tags/v${version}";
    hash = "sha256-JVrAIspRL6XvDd/AnPFt9IJPQ0hY1KPwXvldAfwYkzU=";
  };

  patches = [
    ./0001-fix-build.patch # run go get -u. Old dependency can't run correctly on go 1.23
  ];

  vendorHash = "sha256-WpX5I9PK7xuln6BkIEW2qIF1K/BgaEu/gkJsz+ThVk0=";

  passthru.updateScript = nix-update-script { };

  allowGoReference = true;

  meta = {
    description = "Detect ineffectual assignments in Go code";
    mainProgram = "ineffassign";
    homepage = "https://github.com/gordonklaus/ineffassign";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kalbasit
      bot-wxt1221
    ];
  };
}
