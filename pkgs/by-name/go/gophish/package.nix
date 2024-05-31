{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gophish";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "gophish";
    repo = "gophish";
    rev = "v${version}";
    hash = "sha256-6OUhRB2d8k7h9tI3IPKy9f1KoEx1mvGbxQZF1sCngqs=";
  };

  vendorHash = "sha256-2seQCVALU35l+aAsfag0W19FWlSTlEsSmxTmKKi3A+0=";

  meta = with lib; {
    description = "Open-Source Phishing Toolkit";
    longDescription = ''
      Open-source phishing toolkit designed for businesses and penetration testers.
      Provides the ability to quickly and easily setup and execute phishing engagements and security awareness training.
    '';
    homepage = "https://github.com/gophish/gophish";
    license = licenses.mit;
    maintainers = with maintainers; [ mib ];
    mainProgram = "gophish";
  };
}
