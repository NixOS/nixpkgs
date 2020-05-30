{ stdenv, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "terraform-provider-vpsadmin";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "vpsfreecz";
    repo = "terraform-provider-vpsadmin";
    rev = "v${version}";
    hash = "sha256-+6jRjcManQdoKh7ewOJI1UaulY5OSbkIUHmtrBI33u4=";
  };

  vendorSha256 = "0j90fnzba23mwf9bzf9w5h0hszkl3h61p5i780s9v9c0hbzhbqsh";

  subPackages = [ "." ];

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postInstall = "mv $out/bin/${pname}{,_v${version}}";

  meta = with stdenv.lib; {
    description = "Terraform provider for vpsAdmin";
    homepage = "https://github.com/vpsfreecz/terraform-provider-vpsadmin";
    license = licenses.mpl20;
    maintainers = with maintainers; [ zimbatm ];
  };
}