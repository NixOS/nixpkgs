{ stdenv, rustPlatform, fetchFromGitHub, stfl, sqlite, curl, gettext, pkgconfig, libxml2, json_c, ncurses
, asciidoctor, libiconv, Security, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "newsboat";
  version = "2.19";

  src = fetchFromGitHub {
    owner = "newsboat";
    repo = "newsboat";
    rev = "r${version}";
    sha256 = "0yyrq8a90l6pkrczm9qvdg75jhsdq0niwp79vrdpm8rsxqpdmfq7";
  };

  cargoSha256 = "1q3jf3d80c0ik38qk8jgbhfz5jxv0cy3lzmkyh2l002azp9hvv59";

  postPatch = ''
    substituteInPlace Makefile --replace "|| true" ""
    # Allow other ncurses versions on Darwin
    substituteInPlace config.sh \
      --replace "ncurses5.4" "ncurses"
  '';

  nativeBuildInputs = [
    pkgconfig
    asciidoctor
    gettext
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ makeWrapper libiconv ];

  buildInputs = [ stfl sqlite curl libxml2 json_c ncurses ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  postBuild = ''
    make
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
