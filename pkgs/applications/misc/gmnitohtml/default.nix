{ lib, buildGoModule, fetchFromSourcehut, scdoc, installShellFiles }:

buildGoModule rec {
  pname = "gmnitohtml";
  version = "0.1.2";

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = pname;
    rev = version;
    hash = "sha256-nKNSLVBBdZI5mkbEUkMv0CIOQIyH3OX+SEFf5O47DFY=";
  };
  vendorHash = "sha256-Cx8x8AISRVTA4Ufd73vOVky97LX23NkizHDingr/zVk=";

  ldflags = [ "-s" "-w" ];

  # Build and install the man pages
  nativeBuildInputs = [ scdoc installShellFiles ];

  postBuild = ''
    make gmnitohtml.1
  '';

  postInstall = ''
    installManPage gmnitohtml.1
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
  };
}
