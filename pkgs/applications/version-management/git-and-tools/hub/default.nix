{ stdenv, buildGoPackage, fetchFromGitHub, ronn, ruby, groff, Security, utillinux }:

buildGoPackage rec {
  name = "hub-${version}";
  version = "2.5.1";

  goPackagePath = "github.com/github/hub";

  src = fetchFromGitHub {
    owner = "github";
    repo = "hub";
    rev = "v${version}";
    sha256 = "0a5i351v998vdwf883qhh39c15x56db01fr9hscz4ha7r9550pqg";
  };

  buildInputs = [ groff ronn ruby utillinux ] ++
    stdenv.lib.optional stdenv.isDarwin Security;

  postPatch = ''
    mkdir bin
    ln -s ${ronn}/bin/ronn bin/ronn
    patchShebangs .
  '';

  postInstall = ''
    cd go/src/${goPackagePath}
    install -D etc/hub.zsh_completion "$bin/share/zsh/site-functions/_hub"
    install -D etc/hub.bash_completion.sh "$bin/etc/bash_completion.d/hub.bash_completion.sh"
    install -D etc/hub.fish_completion  "$bin/share/fish/vendor_completions.d/hub.fish"

    make man-pages
    cp -r share/man $bin/share/man
  '';

  meta = with stdenv.lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";

    license = licenses.mit;
    homepage = https://hub.github.com/;
    maintainers = with maintainers; [ the-kenny ];
    platforms = with platforms; unix;
  };
}
