{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "massren";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "laurent22";
    repo = "massren";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PjF7ani4NdM0Avz0/4D04CZLdvkQHg91E/eFoDXD6ks=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # Possible error about github.com/mattn/go-sqlite3
        "Test_guessEditorCommand"
        "Test_processFileActions"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Easily rename multiple files using your text editor";
    license = lib.licenses.mit;
    homepage = "https://github.com/laurent22/massren";
    maintainers = [ ];
    mainProgram = "massren";
  };
})
