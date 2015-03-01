{ stdenv, fetchurl, spidermonkey_24, unzip, curl, pcre, readline, openssl }:
stdenv.mkDerivation rec {
  name = "edbrowse-3.5.2";
  buildInputs = [ unzip curl pcre readline openssl spidermonkey_24 ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${spidermonkey_24}/include/mozjs-24"
    '';
  installPhase = "installBin src/edbrowse";
  src = fetchurl {
    url = "http://the-brannons.com/edbrowse/${name}.zip";
    sha256 = "5f1ac927d126b8c8fd411231cffa9eba5405013e64994e55e1864b2f85d52714";
  };
  meta = {
    description = "Edbrowse, a Command Line Editor Browser";
    longDescription = ''
      Edbrowse is a combination editor, browser, and mail client that is 100% text based.
      The interface is similar to /bin/ed, though there are many more features, such as editing multiple files simultaneously, and rendering html.
      This program was originally written for blind users, but many sighted users have taken advantage of the unique scripting capabilities of this program, which can be found nowhere else.
      A batch job, or cron job, can access web pages on the internet, submit forms, and send email, with no human intervention whatsoever.
      edbrowse can also tap into databases through odbc. It was primarily written by Karl Dahlke.
      '';
    license = stdenv.lib.licenses.gpl1Plus;
    homepage = http://the-brannons.com/edbrowse/;
    maintainers = [ stdenv.lib.maintainers.schmitthenner ];
  };
}
