{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gophernotes";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "gopherdata";
    repo = "gophernotes";
    rev = "v${version}";
    sha256 = "0hs92bdrsjqafdkhg2fk3z16h307i32mvbm9f6bb80bgsciysh27";
  };

  vendorSha256 = "1ylqf1sx0h2kixnq9f3prn3sha43q3ybd5ay57yy5z79qr8zqvxs";

  meta = with lib; {
    description = "Go kernel for Jupyter notebooks";
    homepage = "https://github.com/gopherdata/gophernotes";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
    platforms = platforms.all;
  };
}
