{ stdenv, git, fetchFromGitHub
, gitwebTheme ? false }:

let
  gitwebThemeSrc = fetchFromGitHub {
    owner = "kogakure";
    repo = "gitweb-theme";
    rev = "049b88e664a359f8ec25dc6f531b7e2aa60dd1a2";
    sha256 = "0wksqma41z36dbv6w6iplkjfdm0ha3njp222fakyh4lismajr71p";
  };
in stdenv.mkDerivation {
  name = "gitweb-${stdenv.lib.getVersion git}";

  src = git.gitweb;

  installPhase = ''
      mkdir $out
      mv * $out

      ${stdenv.lib.optionalString gitwebTheme "cp ${gitwebThemeSrc}/* $out/static"}
  '';

  meta = git.meta // {
    maintainers = with stdenv.lib.maintainers; [ gnidorah ];
  };
}
