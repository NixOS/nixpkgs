{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "exercism";
  version = "3.0.13";

  src = fetchFromGitHub {
    owner  = "exercism";
    repo   = "cli";
    rev    = "v${version}";
    sha256 = "17gvz9a0sn4p36hf4l77bxhhfipf4x998iay31layqwbnzmb4xy7";
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
