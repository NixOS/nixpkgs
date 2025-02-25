{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "enumer";
  version = "1.5.11";

  src = fetchFromGitHub {
    owner = "dmarkham";
    repo = "enumer";
    tag = "v${version}";
    hash = "sha256-zFx4Djar2nC/kanoEkmHTumon2MwKMsoZU6/heUPW2I=";
  };

  vendorHash = "sha256-w9T9PWMJjBJP2MmhGC7e78zbszgCwtVrfO5AQlu/ugQ=";

  meta = with lib; {
    description = "Go tool to auto generate methods for enums";
    homepage = "https://github.com/dmarkham/enumer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "enumer";
  };
}
