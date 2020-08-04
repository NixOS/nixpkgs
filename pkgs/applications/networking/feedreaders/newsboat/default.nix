{ stdenv, rustPlatform, fetchFromGitHub, stfl, sqlite, curl, gettext, pkg-config, libxml2, json_c, ncurses
, asciidoctor, libiconv, Security, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "newsboat";
  version = "2.20.1";

  src = fetchFromGitHub {
    owner = "newsboat";
    repo = "newsboat";
    rev = "r${version}";
    sha256 = "1i9dpkdlsm3ya0w2x4c8kplrp3qzd8slbkcqvzfpqggb67gvczvv";
  };

  cargoSha256 = "1ykffx2lhn4w56qm1wypkg9wsqpvzzrz419qkl95w1384xf3f7ix";

  postPatch = ''
    substituteInPlace Makefile --replace "|| true" ""
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [
    pkg-config
    asciidoctor
    gettext
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ makeWrapper ncurses ];

  buildInputs = [ stfl sqlite curl libxml2 json_c ncurses ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv gettext ];

  postBuild = ''
    make prefix="$out"
  '';

  # TODO: Check if that's still needed
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin " -Wno-error=format-security";

  doCheck = true;

  preCheck = ''
    make test
  '';

  postInstall = ''
    make prefix="$out" install
    cp -r contrib $out
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix DYLD_LIBRARY_PATH : "${stfl}/lib"
    done
  '';

  meta = with stdenv.lib; {
    homepage    = "https://newsboat.org/";
    description = "A fork of Newsbeuter, an RSS/Atom feed reader for the text console";
    maintainers = with maintainers; [ dotlambda nicknovitski ];
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
