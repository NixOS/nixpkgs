{ lib, buildGoPackage, fetchFromGitHub, git, groff, installShellFiles, unixtools, nixosTests }:

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

  nativeBuildInputs = [ groff installShellFiles unixtools.col ];

  postPatch = ''
    patchShebangs .
    substituteInPlace git/git.go --replace "cmd.New(\"git\")" "cmd.New(\"${git}/bin/git\")"
    substituteInPlace commands/args.go --replace "Executable:  \"git\"" "Executable:  \"${git}/bin/git\""
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

  passthru.tests = { inherit (nixosTests) hub; };

  meta = with lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";
    license = licenses.mit;
    homepage = "https://hub.github.com/";
    maintainers = with maintainers; [ globin ];
    platforms = with platforms; unix;
  };
}
