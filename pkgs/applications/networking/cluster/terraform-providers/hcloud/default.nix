{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-hcloud";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "hetznercloud";
    repo = pname;
    rev = "v${version}";
    sha256 = "04fa3qr65hg1ylq2933ark5q1za6k0a4ky36a6vrw2dcgpr4f9zs";
  };

  vendorSha256 = "15gcnwylxkgjriqscd4lagmwfssagq0ksrlb2svidw9aahmr7hw0";

  # Spends an awful time in other test folders, apparently tries to reach
  # opencensus and fails.
  checkPhase = ''
    pushd hcloud
    go test -v
    popd
  '';

  postInstall = "mv $out/bin/terraform-provider-hcloud{,_v${version}}";

  meta = with lib; {
    homepage = "https://github.com/cloudfoundry-community/terraform-provider-cloudfoundry";
    description = "Terraform provider for cloudfoundry";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ris ];
  };
}
