{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mLsAT3V6rY7MGs7bq5YctSAEadQ3Ocgm/rdT1Zn6Vo0=";
  };

  vendorHash = "sha256-GHxBoY09od1qrfSVSjWjSC0fDT2HQkmg5ig4iCFH/bo=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/b4b4r07/gomi";
    license = licenses.mit;
    maintainers = with maintainers; [ ozkutuk ];
    mainProgram = "gomi";
  };
}
