{ stdenv, buildGoPackage, fetchFromGitHub, groff, installShellFiles, utillinux }:

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

  nativeBuildInputs = [ groff installShellFiles utillinux ];

  postPatch = ''
    patchShebangs .
  '';

  postInstall = ''
    cd go/src/${goPackagePath}
    installShellCompletion --zsh --name _hub etc/hub.zsh_completion
    installShellCompletion --bash --name hub etc/hub.bash_completion.sh
    installShellCompletion --fish --name hub.fish etc/hub.fish_completion

    LC_ALL=C.UTF8 \
    make man-pages
    installManPage share/man/man[1-9]/*.[1-9]
  '';

  meta = with stdenv.lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";
    license = licenses.mit;
    homepage = "https://hub.github.com/";
    maintainers = with maintainers; [ globin ];
    platforms = with platforms; unix;
  };
}
