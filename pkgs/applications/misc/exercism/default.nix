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

  modSha256 = "0pg0hxrr6jjd03wbjn5y65x02md3h352mnm1gr6vyiv7hn4ws14m";

  subPackages = [ "./exercism" ];

  meta = with stdenv.lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso ];
  };
}
