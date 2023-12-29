{ lib
, stdenv
, fetchFromGitHub
, curl
, duktape
, html-tidy
, openssl
, pcre
, perl
, pkg-config
, quickjs
, readline
, which
}:

stdenv.mkDerivation rec {
  pname = "edbrowse";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "CMB";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZXxzQBAmu7kM3sjqg/rDLBXNucO8sFRFKXV8UxQVQZU=";
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];
  buildInputs = [
    curl
    duktape
    html-tidy
    openssl
    pcre
    perl
    quickjs
    readline
  ];

  patches = [
    # Fixes some small annoyances on src/makefile
    ./0001-small-fixes.patch
  ];

  postPatch = ''
    substituteInPlace src/makefile --replace\
      '-L/usr/local/lib/quickjs' '-L${quickjs}/lib/quickjs'
    for i in $(find ./tools/ -type f ! -name '*.c'); do
      patchShebangs $i
    done
  '';

  makeFlags = [
    "-C" "src"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    homepage = "https://edbrowse.org/";
    description = "Command Line Editor Browser";
    longDescription = ''
      Edbrowse is a combination editor, browser, and mail client that is 100%
      text based. The interface is similar to /bin/ed, though there are many
      more features, such as editing multiple files simultaneously, and
      rendering html. This program was originally written for blind users, but
      many sighted users have taken advantage of the unique scripting
      capabilities of this program, which can be found nowhere else. A batch
      job, or cron job, can access web pages on the internet, submit forms, and
      send email, with no human intervention whatsoever. edbrowse can also tap
      into databases through odbc. It was primarily written by Karl Dahlke.
    '';
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ schmitthenner vrthra equirosa ];
    platforms = platforms.linux;
    mainProgram = "edbrowse";
  };
}
# TODO: send the patch to upstream developers
