{ stdenv, buildGoPackage, fetchFromGitHub, groff, Security, utillinux }:

buildGoPackage rec {
  pname = "hub";
  version = "2.14.2";

  goPackagePath = "github.com/github/hub";

  # Only needed to build the man-pages
  excludedPackages = [ "github.com/github/hub/md2roff-bin" ];

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qjab3dpia1jdlszz3xxix76lqrm4zbmqzd9ymld7h06awzsg2vh";
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
    maintainers = with maintainers; [ the-kenny globin ];
    platforms = with platforms; unix;
  };
}
