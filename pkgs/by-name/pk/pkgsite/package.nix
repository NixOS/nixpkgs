{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "1b7f032dee11d6534119541bc3e03f0fcbcc4995";
    hash = "sha256-++7gtFcp5mD480LfiFmr+7O8ZA3kO9DWZpyLlXagZMI=";
  };

  vendorHash = "sha256-wbK//T/kE55Wx/Vn5Zl7VudvcEPEAqzKzlMZdcx6PIs=";

  subPackages = [ "cmd/pkgsite" ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Official tool to extract and generate documentation for Go projects like pkg.go.dev";
    homepage = "https://github.com/golang/pkgsite";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "pkgsite";
  };
}
