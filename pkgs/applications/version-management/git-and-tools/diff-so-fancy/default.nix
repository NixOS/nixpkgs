{stdenv, git, perl, ncurses, coreutils, fetchFromGitHub, makeWrapper, ...}:

stdenv.mkDerivation rec {
  name = "diff-so-fancy-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "so-fancy";
    repo = "diff-so-fancy";
    rev = "v${version}";
    sha256 = "1hgppp8ngjbjzbi96529p36hzi0ysdndrh6d6m71gs21am8v4m9r";
  };

  # Perl is needed here for patchShebangs
  nativeBuildInputs = [ perl makeWrapper ];

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/bin $out/lib/diff-so-fancy

    # diff-so-fancy executable searches for it's library relative to
    # itself, so we are copying executable to lib, and only symlink it
    # from bin/
    cp diff-so-fancy $out/lib/diff-so-fancy
    cp -r lib $out/lib/diff-so-fancy
    ln -s $out/lib/diff-so-fancy/diff-so-fancy $out/bin

    # ncurses is needed for `tput`
    wrapProgram $out/lib/diff-so-fancy/diff-so-fancy \
      --prefix PATH : "${git}/share/git/contrib/diff-highlight" \
      --prefix PATH : "${git}/bin" \
      --prefix PATH : "${coreutils}/bin" \
      --prefix PATH : "${ncurses.out}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/so-fancy/diff-so-fancy;
    description = "Good-looking diffs filter for git";
    license = licenses.mit;
    platforms = platforms.all;
    longDescription = ''
      diff-so-fancy builds on the good-lookin' output of git contrib's
      diff-highlight to upgrade your diffs' appearances.
    '';
    maintainers = with maintainers; [ fpletz ];
  };
}
