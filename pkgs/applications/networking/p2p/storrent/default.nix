{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "storrent-unstable";
  version = "2021-10-10";

  src = fetchFromGitHub {
    owner = "jech";
    repo = "storrent";
    rev = "681733cf74de08bea251ada672ea8c666eb1b679";
    sha256 = "0grrqgawswb44fahf40060jl691rlyccwlqkljvgy8mzzw1kjzj4";
  };

  vendorSha256 = "0sz2fz7bqgwd5i7sacyxs7bmb8ly6xrxrakqi9c446vzlkh898hj";

  meta = with lib; {
    homepage = "https://github.com/jech/storrent";
    description = "An implementation of the BitTorrent protocol that is optimised for streaming media";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
