{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fluxctl";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flux";
    rev = version;
    sha256 = "1yk78w9cwssk5y69iapfzqf7mnrkam3w64x4zsx3zjpdmvp9dq7l";
  };

  modSha256 = "17rh8yilxqv0dwljwm5ay43diwcy5pa1g2jff9wyhsh8q7sy9wln";

  subPackages = [ "cmd/fluxctl" ];

  meta = with stdenv.lib; {
    description = "CLI client for Flux, the GitOps Kubernetes operator";
    homepage = "https://github.com/fluxcd/flux";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih filalex77 ];
  };
}
