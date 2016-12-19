{ stdenv, fetchurl, spidermonkey_24, unzip, curl, pcre, readline, openssl, perl, html-tidy }:
stdenv.mkDerivation rec {
  name = "edbrowse-${version}";
  version = "3.6.1";

  nativeBuildInputs = [ unzip ];
  buildInputs = [ curl pcre readline openssl spidermonkey_24 perl html-tidy ];

  patchPhase = ''
    substituteInPlace src/ebjs.c --replace \"edbrowse-js\" \"$out/bin/edbrowse-js\"
    for i in ./tools/*.pl
    do
      substituteInPlace $i --replace "/usr/bin/perl" "${perl}/bin/perl"
    done
  '';

  NIX_CFLAGS_COMPILE = "-I${spidermonkey_24.dev}/include/mozjs-24";
  makeFlags = "-C src prefix=$(out)";

  src = fetchurl {
    url = "http://edbrowse.org/${name}.zip";
    sha256 = "1grkn09r31nmvcnm76jkd8aclmd9n5141mpqvb86wndp9pa7gz7q";
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
