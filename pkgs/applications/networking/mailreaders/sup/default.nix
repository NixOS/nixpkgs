{ stdenv, fetchurl, ncurses, ruby, rake, rubygems, makeWrapper }:

stdenv.mkDerivation {
  name = "sup-d21f027afcd6a4031de9619acd8dacbd2f2f4fd4";
  
  meta = {
    homepage = http://supmua.org;
    description = "A curses threads-with-tags style email client";
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };

  dontStrip = true;

  src = fetchurl {
    url = "https://github.com/sup-heliotrope/sup/archive/d21f027afcd6a4031de9619acd8dacbd2f2f4fd4.tar.gz";
    sha256 = "0syifva6pqrg3nyy7xx7nan9zswb4ls6bkk96vi9ki2ly1ymwcdp";
  };

  configurePhase = "";

  buildInputs = [ ncurses ruby rake rubygems makeWrapper ];

  buildPhase = "rake gem";

  installPhase = ''
    export HOME=$TMP/home; mkdir -pv "$HOME"
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri pkg/sup-999.gem
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri gpgme --version 1.0.8

    addToSearchPath GEM_PATH $out/${ruby.gemPath}

    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix GEM_PATH : "$GEM_PATH"
    done

    for prog in $out/gems/*/bin/*; do
      [[ -e "$out/bin/$(basename $prog)" ]]
    done
  '';
}

