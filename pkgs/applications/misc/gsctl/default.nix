{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gsctl";
  version = "0.15.4";

  goPackagePath = "github.com/giantswarm/gsctl";

  src = fetchFromGitHub {
    owner = "giantswarm";
    repo = pname;
    rev  = version;
    sha256 = "0s5bli08wfd9xszx3kc90k51vlgjc00r0qg4mikb6qdc4pxpgsxj";
  };

  meta = with stdenv.lib; {
    description = "The Giant Swarm command line interface";
    homepage = https://github.com/giantswarm/gsctl;
    license = licenses.asl20;
    maintainers = with maintainers; [ joesalisbury ];
  };
}
