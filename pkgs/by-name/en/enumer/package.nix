{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "enumer";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dmarkham";
    repo = "enumer";
    tag = "v${version}";
    hash = "sha256-6K9xsJ9VmsfMDAUZZpQPtwZKzyITuRy2mmduwhya9EY=";
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
