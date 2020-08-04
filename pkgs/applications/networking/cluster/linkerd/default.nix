{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule {
  pname = "linkerd-unstable";
  version = "2020-05-01";

  src = fetchFromGitHub {
    owner = "linkerd";
    repo = "linkerd2";
    rev = "9e9f3bb1e2aeab8cf20f98f5cad159bbb6f24883";
    sha256 = "1pvj31wz1klwhcqga1m8kixdqsxwmppp9ix6r3wpp4dwfig45fm0";
  };

  vendorSha256 = "0vls58ld50jca5yn73kvg3lx4z83cc7skky54a90pkbj737y58pz";

  subPackages = [ "cli/cmd" ];

  meta = with stdenv.lib; {
    description = "A service mesh for Kubernetes and beyond.";
    homepage = "https://linkerd.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih ];
  };
}
