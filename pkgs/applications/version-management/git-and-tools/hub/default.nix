{ stdenv, buildGoPackage, fetchFromGitHub, groff, Security, utillinux }:

buildGoPackage rec {
  pname = "hub";
  version = "2.11.2";

  goPackagePath = "github.com/github/hub";

  # Only needed to build the man-pages
  excludedPackages = [ "github.com/github/hub/md2roff-bin" ];

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "11ipc2vpy52r1ql9r4iyam1sjchb7f01ffc39fvz6d5hhjaz3i9b";
  };

  nativeBuildInputs = [ groff utillinux ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  postPatch = ''
    patchShebangs .
  '';

  postInstall = ''
    cd go/src/${goPackagePath}
    install -D etc/hub.zsh_completion "$bin/share/zsh/site-functions/_hub"
    install -D etc/hub.bash_completion.sh "$bin/share/bash-completion/completions/hub"
    install -D etc/hub.fish_completion  "$bin/share/fish/vendor_completions.d/hub.fish"

    LC_ALL=C.UTF8 \
    make man-pages
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
