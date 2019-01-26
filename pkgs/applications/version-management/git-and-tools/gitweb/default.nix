{ stdenv, git, gzip, perlPackages, fetchFromGitHub
, gitwebTheme ? false }:

let
  gitwebPerlLibs = with perlPackages; [ CGI HTMLParser CGIFast FCGI FCGIProcManager HTMLTagCloud ];
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

      # gzip (and optionally bzip2, xz, zip) are runtime dependencies for
      # gitweb.cgi, need to patch so that it's found
      sed -i -e "s|'compressor' => \['gzip'|'compressor' => ['${gzip}/bin/gzip'|" \
          $out/gitweb.cgi
      # Give access to CGI.pm and friends (was removed from perl core in 5.22)
      for p in ${stdenv.lib.concatStringsSep " " gitwebPerlLibs}; do
          sed -i -e "/use CGI /i use lib \"$p/${perlPackages.perl.libPrefix}\";" \
              "$out/gitweb.cgi"
      done

      ${stdenv.lib.optionalString gitwebTheme "cp ${gitwebThemeSrc}/* $out/static"}
  '';

  meta = git.meta // {
    maintainers = with stdenv.lib.maintainers; [ gnidorah ];
  };
}
