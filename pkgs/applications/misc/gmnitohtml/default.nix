{ lib, buildGoModule, fetchFromSourcehut, scdoc, installShellFiles }:

buildGoModule rec {
  pname = "gmnitohtml";
  version = "0.1.3";

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = pname;
    rev = version;
    hash = "sha256-9lsZgh/OyxAu1rsixD6XUgQzR1xDGOxGt0sR12zrs2M=";
  };
  vendorHash = "sha256-ppplXXqb2DM/AU+B+LefndrBiiTgCRNw6hEupfeWr+o=";

  ldflags = [ "-s" "-w" ];

  # Build and install the man pages
  nativeBuildInputs = [ scdoc installShellFiles ];

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

  meta = with lib; {
    homepage = "https://git.sr.ht/~adnano/gmnitohtml";
    changelog = "https://git.sr.ht/~adnano/gmnitohtml/log";
    description = "Gemini text to HTML converter";
    longDescription = ''
      he gmnitohtml utility reads Gemini text from the standard input and writes
      HTML to the standard output.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ jk sikmir ];
    mainProgram = "gmnitohtml";
  };
}
