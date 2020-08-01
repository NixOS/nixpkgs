{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lefthook";
  version = "0.7.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Arkweid";
    repo = "lefthook";
    sha256 = "1ciyxjx3r3dcl8xas49kqsjshs1bv4pafmfmhdfyfdvlaj374hgj";
  };

  vendorSha256 = "1pdrw4vwbj9cka2pjbjvxviigfvnrf8sgws27ixwwiblbkj4isc8";

  meta = with stdenv.lib; {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/Arkweid/lefthook";
    license = licenses.mit;
    maintainers = with maintainers; [ rencire ];
  };
}
