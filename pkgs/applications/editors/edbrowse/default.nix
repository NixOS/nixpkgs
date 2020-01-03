{ stdenv, fetchFromGitHub, duktape, curl, pcre, readline, openssl, perl, html-tidy }:

stdenv.mkDerivation rec {
  pname = "edbrowse";
  version = "3.7.6";

  buildInputs = [ curl pcre readline openssl duktape perl html-tidy ];

  postPatch = ''
    for i in ./tools/*.pl
    do
      substituteInPlace $i --replace "/usr/bin/perl" "${perl}/bin/perl"
    done
  '';

  makeFlags = [
    "-C" "src"
    "prefix=${placeholder "out"}"
  ];

  src = fetchFromGitHub {
    owner = "CMB";
    repo = "edbrowse";
    rev = "v${version}";
    sha256 = "0yk4djb9q8ll94fs57y706bsqlar4pfx6ysasvkzj146926lrh8a";
  };
  meta = with stdenv.lib; {
    description = "Command Line Editor Browser";
    longDescription = ''
      Edbrowse is a combination editor, browser, and mail client that is 100% text based.
      The interface is similar to /bin/ed, though there are many more features, such as editing multiple files simultaneously, and rendering html.
      This program was originally written for blind users, but many sighted users have taken advantage of the unique scripting capabilities of this program, which can be found nowhere else.
      A batch job, or cron job, can access web pages on the internet, submit forms, and send email, with no human intervention whatsoever.
      edbrowse can also tap into databases through odbc. It was primarily written by Karl Dahlke.
      '';
    license = licenses.gpl1Plus;
    homepage = "https://edbrowse.org/";
    maintainers = with maintainers; [ schmitthenner vrthra equirosa ];
    platforms = platforms.linux;
  };
}
