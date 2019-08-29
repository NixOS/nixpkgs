{ stdenv, fetchFromGitHub, fetchpatch, duktape, curl, pcre, readline, openssl, perl, html-tidy }:

stdenv.mkDerivation rec {
  name = "edbrowse-${version}";
  version = "3.7.4";

  buildInputs = [ curl pcre readline openssl duktape perl html-tidy ];

  patches = [
    # Fix build against recent libcurl
    (fetchpatch {
      url = https://github.com/CMB/edbrowse/commit/5d2b9e21fdf019f461ebe62738d615428d5db963.diff;
      sha256 = "167q8n0syj3iv6lxrbpv4kvb63j4byj4qxrxayy08bah3pss3gky";
    })
  ];

  postPatch = ''
    for i in ./tools/*.pl
    do
      substituteInPlace $i --replace "/usr/bin/perl" "${perl}/bin/perl"
    done
  '';

  makeFlags = "-C src prefix=$(out)";

  src = fetchFromGitHub {
    owner = "CMB";
    repo = "edbrowse";
    rev = "v${version}";
    sha256 = "0i9ivyfy1dd16c89f392kwx6wxgkkpyq2hl32jhzra0fb0zyl0k6";
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
    homepage = http://edbrowse.org/;
    maintainers = [ maintainers.schmitthenner maintainers.vrthra ];
    platforms = platforms.linux;
  };
}
