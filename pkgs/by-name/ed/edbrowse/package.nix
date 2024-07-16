{ lib
, curl
, duktape
, fetchFromGitHub
, html-tidy
, openssl
, pcre
, perl
, pkg-config
, quickjs
, readline
, stdenv
, unixODBC
, which
, withODBC ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edbrowse";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "CMB";
    repo = "edbrowse";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZXxzQBAmu7kM3sjqg/rDLBXNucO8sFRFKXV8UxQVQZU=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    # Fixes some small annoyances on src/makefile
     ./0001-small-fixes.patch
  ];

  patchFlags =  [
    "-p2"
  ];

  postPatch = ''
    for file in $(find ./tools/ -type f ! -name '*.c'); do
      patchShebangs $file
    done
  '';

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
  ] ++ lib.optionals withODBC [
    unixODBC
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preBuild = ''
    buildFlagsArray+=(
      BUILD_EDBR_ODBC=${if withODBC then "on" else "off"}
      EBDEMIN=on
      QUICKJS_LDFLAGS="-L${quickjs}/lib/quickjs -lquickjs -ldl -latomic"
    )
  '';

  meta = {
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
    license = with lib.licenses; [ gpl1Plus ];
    mainProgram = "edbrowse";
    maintainers = with lib.maintainers; [
      schmitthenner
      equirosa
      AndersonTorres
    ];
    platforms = lib.platforms.linux;
  };
})
# TODO: send the patch to upstream developers
