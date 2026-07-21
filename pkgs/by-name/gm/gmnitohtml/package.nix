{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  scdoc,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gmnitohtml";
  version = "0.1.3";

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = "gmnitohtml";
    rev = finalAttrs.version;
    hash = "sha256-9lsZgh/OyxAu1rsixD6XUgQzR1xDGOxGt0sR12zrs2M=";
  };
  vendorHash = "sha256-ppplXXqb2DM/AU+B+LefndrBiiTgCRNw6hEupfeWr+o=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Build and install the man pages
  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  postBuild = ''
    make docs
  '';

  postInstall = ''
    installManPage docs/gmnitohtml.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/gmnitohtml --help
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://git.sr.ht/~adnano/gmnitohtml";
    changelog = "https://git.sr.ht/~adnano/gmnitohtml/log";
    description = "Gemini text to HTML converter";
    longDescription = ''
      he gmnitohtml utility reads Gemini text from the standard input and writes
      HTML to the standard output.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
      sikmir
    ];
    mainProgram = "gmnitohtml";
  };
})
