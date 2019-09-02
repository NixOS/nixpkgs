{ stdenv, fetchFromGitHub, buildGoPackage }:
buildGoPackage rec {
  name = "terraform-provider-elasticsearch-${version}";
  version = "0.6.0";

  goPackagePath = "github.com/phillbaker/terraform-provider-elasticsearch";

  # ./deps.nix was generated using the work-around described in:
  # https://github.com/kamilchm/go2nix/issues/19
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "phillbaker";
    repo = "terraform-provider-elasticsearch";
    rev = "v${version}";
    sha256 = "04i7jwhm1mg4m8p7y6yg83j76fx0ncallzbza1g1wc5cjjbkvgs2";
  };

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-elasticsearch{,_v${version}}";

  meta = with stdenv.lib; {
    description = "Terraform provider for elasticsearch";
    homepage = "https://github.com/phillbaker/terraform-provider-elasticsearch";
    license = licenses.mpl20;
    maintainers = with maintainers; [ basvandijk ];
  };
}
