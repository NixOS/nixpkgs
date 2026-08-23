{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule {
  pname = "gx-go";
  version = "1.9.0-unstable-2020-03-03";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "whyrusleeping";
    repo = "gx-go";
    rev = "9c30fadeac4aee8346d28c36d6bd5063da3d189a";
    hash = "sha256-lrfAyqAyRnhyw9dPURM1NeFIJW/Zug53ThZiwa89z2M=";
  };

  vendorHash = "sha256-A3jZYu7+LGCukzlrxgIPmnkcxSoWm5YJZmFG3hliMm4=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  preVersionCheck = ''
    export version="1.9.0"
  '';

  meta = {
    description = "Tool for importing go packages into gx";
    mainProgram = "gx-go";
    homepage = "https://github.com/whyrusleeping/gx-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
