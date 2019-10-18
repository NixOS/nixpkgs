{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "exercism";
  version = "3.0.12";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "1xvxcl7j5izx5lgmjd97zd28lg2sydwgbgn2cnisz5r0d27pj3ra";
  };

  modSha256 = "1p4xjm2zb2xc1qpprj5wlcc9pangbxpx16hx3nbr2caa5gdll5y8";

  meta = with stdenv.lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso ];
  };
}
