{ stdenv, buildGoPackage, fetchFromGitHub, ronn, ruby, groff, Security, utillinux, git, glibcLocales }:

buildGoPackage rec {
  pname = "hub";
  version = "2.9.0";

  goPackagePath = "github.com/github/hub";

  # Only needed to build the man-pages
  excludedPackages = [ "github.com/github/hub/md2roff-bin" ];

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yxpr606xx23l8823hjqj16cvjjrwb28c7z08ml1pkfvaf7w4n81";
  };

  nativeBuildInputs = [ groff ronn utillinux glibcLocales ];
  buildInputs = [ ruby ] ++
    stdenv.lib.optional stdenv.isDarwin Security;

  postPatch = ''
    patchShebangs .
  '';

  postInstall = ''
    cd go/src/${goPackagePath}
    install -D etc/hub.zsh_completion "$bin/share/zsh/site-functions/_hub"
    install -D etc/hub.bash_completion.sh "$bin/share/bash-completion/completions/hub"
    install -D etc/hub.fish_completion  "$bin/share/fish/vendor_completions.d/hub.fish"

    PATH=$PATH:${git}/bin LC_ALL=en_US.utf-8 make man-pages
    cp -vr --parents share/man/man[1-9]/*.[1-9] $bin/
  '';

  meta = with stdenv.lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";
    license = licenses.mit;
    homepage = https://hub.github.com/;
    maintainers = with maintainers; [ the-kenny ];
    platforms = with platforms; unix;
  };
}
