{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "stc";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = pname;
    rev = version;
    sha256 = "sha256-QdU480at8VvuHpYmEKagnBotjM7ikOsVLJeedJ2qtjw=";
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
