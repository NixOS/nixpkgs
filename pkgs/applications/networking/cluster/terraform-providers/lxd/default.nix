{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-lxd";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "sl1pm4t";
    repo = "terraform-provider-lxd";
    rev = "v${version}";
    sha256 = "1k54021178zybh9dqly2ly8ji9x5rka8dn9xd6rv7gkcl5w3y6fv";
  };

  vendorSha256 = "1shdpl1zsbbpc3mfs0l65ykq2h15ggvqylaixcap4j4lfl7m9my0";

  postBuild = "mv ../go/bin/terraform-provider-lxd{,_v${version}}";

  meta = with stdenv.lib; {
    homepage = "https://github.com/sl1pm4t/terraform-provider-lxd";
    description = "Terraform provider for lxd";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ gila ];
  };
}
