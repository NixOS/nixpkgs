{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "senv";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "SpectralOps";
    repo = pname;
    rev = "v${version}";
    sha256 = "014422sdks2xlpsgvynwibz25jg1fj5s8dcf8b1j6djgq5glhfaf";
  };

  vendorSha256 = "05n55yf75r7i9kl56kw9x6hgmyf5bva5dzp9ni2ws0lb1389grfc";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Friends don't let friends leak secrets on their terminal window";
    homepage = "https://github.com/SpectralOps/senv";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
