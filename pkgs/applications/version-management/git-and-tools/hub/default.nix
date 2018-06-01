{ stdenv, fetchgit, go, ronn, groff, utillinux, Security }:

stdenv.mkDerivation rec {
  name = "hub-${version}";
  version = "2.3.0";

  src = fetchgit {
    url = https://github.com/github/hub.git;
    rev = "refs/tags/v${version}";
    sha256 = "0rx5izxgjxh4jdn991x90xvgbc7nhwx15pkmmzc8rkdzf0hnas1s";
  };


  buildInputs = [ go ronn groff utillinux ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  buildPhase = ''
    mkdir bin
    ln -s ${ronn}/bin/ronn bin/ronn

    patchShebangs .
    make all man-pages
  '';

  installPhase = ''
    prefix=$out sh -x < script/install.sh

    mkdir -p "$out/share/zsh/site-functions"
    cp "etc/hub.zsh_completion" "$out/share/zsh/site-functions/_hub"

    mkdir -p "$out/etc/bash_completion.d"
    cp "etc/hub.bash_completion.sh" "$out/etc/bash_completion.d/"

    # Should we also install provided git-hooks?
    # And fish completion?
  '';

  meta = with stdenv.lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";

    license = licenses.mit;
    homepage = https://hub.github.com/;
    maintainers = with maintainers; [ the-kenny ];
    platforms = with platforms; unix;
  };
}
