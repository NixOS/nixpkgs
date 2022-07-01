{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.25.21";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "05yij47r9nac4mmpbrdvpawsas91vkxmi1pfipbwn6xsq960q8nf";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/derailed/k9s/cmd.version=${version}"
    "-X github.com/derailed/k9s/cmd.commit=${src.rev}"
  ];

  vendorSha256 = "sha256-wL8Unht/ZRAGDuC/U4SFV5PdExy78F4DMyM8+7CMtOY=";

  preCheck = "export HOME=$(mktemp -d)";

  # TODO investigate why some config tests are failing
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih markus1189 bryanasdev000 ];
  };
}
