{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stc";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = pname;
    rev = version;
    sha256 = "sha256-Hv8md27LUB/d1MNqNEw7UX7r3tMYdguuGP3xOI2LWBk=";
  };

  vendorHash = "sha256-TnWCviLstm6kS34cNkrVGS9RZ21cVX/jmx8d+KytB0c=";

  meta = with lib; {
    description = "Syncthing CLI Tool";
    homepage = "https://github.com/tenox7/stc";
    changelog = "https://github.com/tenox7/stc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
    mainProgram = "stc";
  };
}
