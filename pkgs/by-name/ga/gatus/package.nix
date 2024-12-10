{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gatus";
  version = "5.11.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-x9agE3ZctH9fudUA0uTVUiCUxiEEn/I4Lz47oIyUee0=";
  };

  vendorHash = "sha256-Cb9G24SinU+ln9iVSHLsD0TNt2sIfYsHGmQI/vZekPI=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Automated developer-oriented status page";
    homepage = "https://gatus.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ undefined-moe ];
    mainProgram = "gatus";
  };
}
