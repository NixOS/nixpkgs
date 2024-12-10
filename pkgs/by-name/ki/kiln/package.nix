{ lib, buildGoModule, fetchFromSourcehut, scdoc, installShellFiles }:

buildGoModule rec {
  pname = "kiln";
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = "kiln";
    rev = version;
    hash = "sha256-BbKd+0Dmo6RaoS0N7rQmSGJasuJb6dl43GZ7LdMBy/o=";
  };

  nativeBuildInputs = [ scdoc installShellFiles ];

  vendorHash = "sha256-3s1+/RxOTNVFX9FnS94jLVGSr5IjZC/XucmnkxHhk5Q=";

  postInstall = ''
    scdoc < docs/kiln.1.scd > docs/kiln.1
    installManPage docs/kiln.1
  '';

  meta = with lib; {
    description = "Simple static site generator for Gemini";
    homepage = "https://kiln.adnano.co/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "kiln";
  };
}
