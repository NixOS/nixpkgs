{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "argo-expr";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "blacha";
    repo = "argo-expr";
    rev = "v${version}";
    hash = "sha256-XQnPFzT3PRmKeAQXLzBE5R2VvXotzxmsq+u9u5iE1QA=";
  };

  vendorHash = "sha256-HGmJVxmAj9ijsWX+qJ7J9l3uO7WvXtRU2gvx2G7N7/M=";

  ldflags = [ "-X main.Version=v${version}" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Argo expression tester";
    homepage = "https://github.com/blacha/argo-expr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ l0b0 ];
    mainProgram = "argo-expr";
  };
}
