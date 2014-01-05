{ stdenv, fetchgit, ruby, rake, rubygems, makeWrapper, ncursesw_sup
, xapian_ruby, gpgme, libiconvOrEmpty, mime_types, chronic, trollop, lockfile
, gettext, iconv, locale, text, highline, rmail_sup, unicode, gnupg, which }:

stdenv.mkDerivation rec {
  version = "20131130";
  name    = "sup-${version}";
  
  meta = {
    homepage = http://supmua.org;
    description = "A curses threads-with-tags style email client";
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };

  dontStrip = true;

  src = fetchgit {
    url = git://github.com/sup-heliotrope/sup.git;
    rev = "a5a1e39034204ac4b05c9171a71164712690b010";
    sha256 = "0w2w7dcif1ri1qq81csz7gj45rqd9z7hjd6x29awibybyyqyvj5s";
  };

  buildInputs =
    [ ruby rake rubygems makeWrapper gpgme ncursesw_sup xapian_ruby
      libiconvOrEmpty ];

  buildPhase = "rake gem";

  installPhase = ''
    export HOME=$TMP/home; mkdir -pv "$HOME"

    GEM_PATH="$GEM_PATH:$out/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${chronic}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${gettext}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${gpgme}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${highline}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${iconv}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${locale}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${lockfile}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${mime_types}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${ncursesw_sup}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${rmail_sup}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${text}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${trollop}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${unicode}/${ruby.gemPath}"
    GEM_PATH="$GEM_PATH:${xapian_ruby}/${ruby.gemPath}"

    # Don't install some dependencies -- we have already installed
    # the dependencies but gem doesn't acknowledge this
    gem install --no-verbose --install-dir "$out/${ruby.gemPath}" \
        --bindir "$out/bin" --no-rdoc --no-ri pkg/sup-999.gem \
        --ignore-dependencies

    # specify ruby interpreter explicitly
    sed -i '1 s|^.*$|#!${ruby}/bin/ruby|' bin/sup-sync-back-maildir

    cp bin/sup-sync-back-maildir "$out"/bin

    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix GEM_PATH : "$GEM_PATH" --prefix PATH : "${gnupg}/bin:${which}/bin"
    done

    for prog in $out/gems/*/bin/*; do
      [[ -e "$out/bin/$(basename $prog)" ]]
    done
  '';
}
