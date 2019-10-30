{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cheat";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "chrisallenlane";
    repo = "cheat";
    rev = version;
    sha256 = "19w1admdcgld9vlc4fsyc5d9bi6rmwhr2x2ji43za2vjlk34hnnx";
  };

  subPackages = [ "cmd/cheat" ];

  modSha256 = "189cqnfl403f4lk7g9v68mwk93ciglqli639dk4x9091lvn5gq5q";

  meta = with stdenv.lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    homepage = "https://github.com/chrisallenlane/cheat";
  };
}
