{ stdenv, fetchurl, ruby, rake, rubygems, makeWrapper, ncursesw_sup
, xapian_ruby, gpgme, libiconvOrEmpty, mime_types, chronic, trollop, lockfile
, gettext, iconv, locale, text, highline, rmail_sup, unicode, gnupg, which
, bundler, git }:

stdenv.mkDerivation rec {
  version = "0.18.0";
  name    = "sup-${version}";

  meta = {
    description = "A curses threads-with-tags style email client";
    homepage    = http://supmua.org;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    platforms   = stdenv.lib.platforms.unix;
  };

  dontStrip = true;

  src = fetchurl {
    url    = "https://github.com/sup-heliotrope/sup/archive/release-${version}.tar.gz";
    sha256 = "1dhg0i2v0ddhwi32ih5lc56x00kbaikd2wdplgzlshq0nljr9xy0";
  };

  buildInputs =
    [ rake ruby rubygems makeWrapper gpgme ncursesw_sup xapian_ruby
      libiconvOrEmpty git ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    # the builder uses git to get a listing of the files
    git init >/dev/null
    git add .
    git commit -m "message" >/dev/null
    gem build sup.gemspec
  '';

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
        --bindir "$out/bin" --no-rdoc --no-ri sup-${version}.gem \
        --ignore-dependencies >/dev/null

    # specify ruby interpreter explicitly
    sed -i '1 s|^.*$|#!${ruby}/bin/ruby|' bin/sup-sync-back-maildir

    cp bin/sup-sync-back-maildir "$out/bin"

    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix GEM_PATH : "$GEM_PATH" --prefix PATH : "${gnupg}/bin:${which}/bin"
    done

    for prog in $out/gems/*/bin/*; do
      [[ -e "$out/bin/$(basename $prog)" ]]
    done
  '';
}
