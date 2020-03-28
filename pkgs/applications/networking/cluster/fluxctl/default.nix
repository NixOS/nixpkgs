{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "1sk82cnrj5ngcaml54rhh7ak8dg80r25623c4s8p7ybrj1m7krqj";
  };

  modSha256 = "0ij5q31a0818nmqsdql1ii6rhq6nb0liplnw509qih8py7dk5xkg";

  subPackages = [ "cmd/fluxctl" ];

  meta = with stdenv.lib; {
    description = "CLI client for Flux, the GitOps Kubernetes operator";
    homepage = "https://github.com/fluxcd/flux";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih filalex77 ];
  };
}
