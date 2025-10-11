{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "lmt";
  version = "0-unstable-2021-04-21";

  src = fetchFromGitHub {
    owner = "driusan";
    repo = "lmt";
    rev = "62fe18f2f6a6e11c158ff2b2209e1082a4fcd59c";
    hash = "sha256-6/jDh5dfpFAhOspKto2hB8TTSjjh++GkQWjRBaFrYZg=";
  };

  vendorHash = null;

  patches = [ ./0001-module.patch ];

  meta = {
    description = "Extract code from literate markdown files";
    homepage = "https://github.com/driusan/lmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      DPDmancul
    ];
    mainProgram = "lmt";
  };
}
