{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "neo-cowsay";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Code-Hex";
    repo = "Neo-cowsay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MROWbxZ16MIgQGrlQSR8ZX6egoJmIWcyqeRS744JsKQ=";
  };

  __structuredAttrs = true;
  vendorHash = "sha256-A8He1Xw100ogRwRQbtWhD9nEy8UPIWnfP4IqOs5i/yc=";

  modRoot = "./cmd";

  doCheck = false;

  subPackages = [
    "cowsay"
    "cowthink"
  ];

  meta = {
    description = "Cowsay reborn, written in Go";
    homepage = "https://github.com/Code-Hex/Neo-cowsay";
    license =
      with lib.licenses;
      OR [
        artistic2
        gpl3Only
      ];
    mainProgram = "cowsay";
  };
})
