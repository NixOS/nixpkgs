{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.36.1";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j9a7lxspgw63xzz1f8r5fb67jxm5isdvfi5450v20virxch9afi";
  };

  vendorSha256 = "06kx85bf8mjmyhz5gp0la4fr8psnfz6i2rchc22sz2pgmsng1dfr";

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
