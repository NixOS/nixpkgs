{
  fetchurl,
  lib,
  mkDerivation,
  pkg-config,
  python3,
  file,
  bc,
  qtbase,
  qtsvg,
  hunspell,
  callPackage,
  makeWrapper, # , mythes, boost
  lyxHunspellDicts ? (ds: [ ]),
}:
let
  hunspellWithDicts = hunspell.withDicts lyxHunspellDicts;
in
mkDerivation rec {
  version = "2.4.4";
  pname = "lyx";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.4.x/${pname}-${version}.tar.xz";
    hash = "sha256-/6zTdIDzIPPz+PMERf5AiX6d9EyU7oe6BBPjZAhvS5A=";
  };

  passthru = {
    withDicts = lyxHunspellDicts: (callPackage ./default.nix { inherit lyxHunspellDicts; });
  };

  # LaTeX is used from $PATH, as people often want to have it with extra pkgs
  nativeBuildInputs = [
    pkg-config
    makeWrapper
    python3
    qtbase
  ];
  buildInputs = [
    qtbase
    qtsvg
    file # for libmagic
    bc
    hunspell # enchant
    hunspellWithDicts # User configured hunspell dictionaries for spell checking
  ];

  configureFlags = [
    "--enable-qt5"
    #"--without-included-boost"
    /*
      Boost is a huge dependency from which 1.4 MB of libs would be used.
       Using internal boost stuff only increases executable by around 0.2 MB.
    */
    #"--without-included-mythes" # such a small library isn't worth a separate package
  ];

  enableParallelBuilding = true;
  doCheck = true;

  # python is run during runtime to do various tasks
  qtWrapperArgs = [ " --prefix PATH : ${python3}/bin" ];

  installPhase = ''
    make install
    ln -sf ${hunspellWithDicts}/share/hunspell $out/share/lyx/dicts
  '';

  meta = {
    description = "WYSIWYM frontend for LaTeX, DocBook";
    longDescription = ''
      WYSIWYM frontend for LaTeX, DocBook

      To install dictionaries for LyX's spell checker use the Hunspell
      syntax, e.g.
      ```nix
      buildInputs = with pkgs; [
        (lyx.withDicts (ds: with ds; [en_US]))
      ];
      ```

      To install language support for languages other than English,
      install the LaTeX package corresponding to your language
      `texlivePackages.collection-lang*` then follow any other instructions
      on the LyX Wiki for your language.
      If they don't work quite as well or don't exist, try to search
      "<name of major university in your country> lyx manual".
    '';
    homepage = "https://www.lyx.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.vcunat ];
    platforms = lib.platforms.linux;
  };
}
