{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    sha256 = "16zz4xwpqipdmszbz93xxw31hbh7s8pfa9dm64ybyni7wc4lvdy6";
  };

  modSha256 = "18f7cf61yn5jkji5a4v6xw6c7xl40nj32n5w34xmcmszzf64cwkn";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ jpotier ];
  };
}
