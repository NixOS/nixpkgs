{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.07";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "0yrfpj4ph9f321vqfn1zadv44pqa3ivjq9rx6gsz9hlv50gfaqn1";
  };

  vendorSha256 = "1ysqagi4y25bi84h5fhkdimnsigy43klf6hrcqn7q75382fb4bzn";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}
