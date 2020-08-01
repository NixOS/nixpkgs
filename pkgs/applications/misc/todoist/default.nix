{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "todoist";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "0d3c621jaqxd6i58xm6nvi0avrh5mk23r169i95bn73igzw62w33";
  };

  vendorSha256 = "0cznb8glh36dwyyn1gx1ggkwa9zffrrxg52k78brnaczsl0rsmky";

  meta = {
    homepage = "https://github.com/sachaos/todoist";
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
