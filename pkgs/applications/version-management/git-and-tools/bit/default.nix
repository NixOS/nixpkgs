{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "bit";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "chriswalz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dv6ma2vwb21cbxkxzrpmj7cqlhwr7a86i4g728m3y1aclh411sn";
  };

  vendorSha256 = "1j6w7bll4zyp99579dhs2rza4y9kgfz3g8d5grfzgqck6cjj9mn8";

  propagatedBuildInputs = [ git ];

  # Tests require a repository
  doCheck = false;

  meta = with lib; {
    description = "Command-line tool for git";
    homepage = "https://github.com/chriswalz/bit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
