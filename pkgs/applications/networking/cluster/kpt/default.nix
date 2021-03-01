{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.37.1";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4SGCYkx9U6XNUrJfVPgNEhFA75CF8GOrtS4BSm6f7mM=";
  };

  vendorSha256 = "sha256-y/l9k3oTrN+9OGgyiVzCyYi+6lJpcKaEygirytbn9aI=";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/GoogleContainerTools/kpt/run.version=${version}" ];

  meta = with lib; {
    description = "A toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files";
    homepage = "https://googlecontainertools.github.io/kpt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
