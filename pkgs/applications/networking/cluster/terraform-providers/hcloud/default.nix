{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-hcloud";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h4kplrmpsbwa0nq3zyqa0cnvhv1s5avdrjyf1k1f2z6b6h4gynf";
  };

  vendorSha256 = "070p34g0ca55rmfdwf1l53yr8vyhmm5sb8hm8q036n066yp03yfs";

  # Spends an awful time in other test folders, apparently tries to reach
  # opencensus and fails.
  checkPhase = ''
    pushd hcloud
    go test -v
    popd
  '';

  postInstall = "mv $out/bin/terraform-provider-hcloud{,_v${version}}";

  meta = with stdenv.lib; {
    homepage = "https://github.com/cloudfoundry-community/terraform-provider-cloudfoundry";
    description = "Terraform provider for cloudfoundry";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ris ];
  };
}
