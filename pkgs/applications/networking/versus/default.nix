{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "versus";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "INFURA";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j5mj9gwwvgx7r1svlg14dpcqlj8mhwlf7sampkkih6bv92qfzcd";
  };

  vendorSha256 = "1d12jcd8crxcgp5m8ga691wivim4cg8cbz4pzgxp0jhzg9jplpbv";

  meta = with lib; {
    description = "Benchmark multiple API endpoints against each other";
    homepage = "https://github.com/INFURA/versus";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
