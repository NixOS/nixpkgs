{ stdenv, fetchurl, ruby, rake, rubygems, makeWrapper, ncursesw_sup
, xapian_full_alaveteli, gpgme, libiconvOrEmpty }:

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

  buildInputs =
    [ ruby rake rubygems makeWrapper gpgme ncursesw_sup xapian_full_alaveteli
      libiconvOrEmpty ];

  buildPhase = "rake gem";

  # TODO: Move gem dependencies out

  installPhase = ''
    export HOME=$TMP/home; mkdir -pv "$HOME"

    GEM_PATH="$GEM_PATH:$out/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${ncursesw_sup}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${xapian_full_alaveteli}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${gpgme}/${ruby.gemPath}"

    # Don't install some dependencies -- we have already installed
    # ncursesw-sup, xapian-full-alaveteli and gpgme, but gem doesn't acknowledge
    # this
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri pkg/sup-999.gem \
        --ignore-dependencies

    # Now install the dependencies that will work out of the box
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri rmail
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri trollop
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri lockfile
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri mime-types
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri gettext
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri chronic
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri iconv

    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix GEM_PATH : "$GEM_PATH"
    done

    for prog in $out/gems/*/bin/*; do
      [[ -e "$out/bin/$(basename $prog)" ]]
    done
  '';
}

