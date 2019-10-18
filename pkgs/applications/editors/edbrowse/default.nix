{ stdenv, buildPackages, fetchFromGitHub, fetchpatch
, curl, duktape, html-tidy, openssl, pcre, perl, readline
, odbcSupport ? true
, unixODBC ? null
}:

let
  inherit (stdenv) lib;
in

stdenv.mkDerivation rec {
  pname = "edbrowse";
  version = "3.7.4";

  src = fetchFromGitHub {
    owner = "CMB";
    repo = "edbrowse";
    rev = "v${version}";
    sha256 = "0i9ivyfy1dd16c89f392kwx6wxgkkpyq2hl32jhzra0fb0zyl0k6";
  };

  nativeBuildInputs = [
    buildPackages.cmake
  ];
  buildInputs = [
    curl
    duktape
    html-tidy
    openssl
    pcre
    perl
    readline
  ] ++ lib.optional odbcSupport [
    unixODBC
  ];

  patches = [
    # Fix build against recent libcurl
    (fetchpatch {
      url = https://github.com/CMB/edbrowse/commit/5d2b9e21fdf019f461ebe62738d615428d5db963.diff;
      sha256 = "167q8n0syj3iv6lxrbpv4kvb63j4byj4qxrxayy08bah3pss3gky";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'Dir "/usr/' 'Dir "'
  '';

  configureFlags = lib.optional odbcSupport [ "-DBUILD_EDBR_ODBC" ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Command Line Editor Browser";
    longDescription = ''
      Edbrowse is a combination editor, browser, and mail client that is 100% text based.
      The interface is similar to /bin/ed, though there are many more features, such as editing multiple files simultaneously, and rendering html.
      This program was originally written for blind users, but many sighted users have taken advantage of the unique scripting capabilities of this program, which can be found nowhere else.
      A batch job, or cron job, can access web pages on the internet, submit forms, and send email, with no human intervention whatsoever.
      edbrowse can also tap into databases through odbc. It was primarily written by Karl Dahlke.
      '';
    license = lib.licenses.gpl1Plus;
    homepage = http://edbrowse.org/;
    maintainers = let m = lib.maintainers; in [ m.schmitthenner m.vrthra ];
    platforms = lib.platforms.linux;
  };
}
