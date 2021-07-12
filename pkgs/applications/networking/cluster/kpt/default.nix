{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MBZa4LdpCZnVVbjzkYpPi9/CYGqVLeYy2N/AS1PSYBE=";
  };

  vendorSha256 = "sha256-P0cN8aw62nPD1OlUAw1E36YxptxtPqqruZfDDG4Ag2w=";

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
