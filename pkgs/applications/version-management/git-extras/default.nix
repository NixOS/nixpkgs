{ lib
, stdenv
, fetchFromGitHub
, unixtools
, which
}:

stdenv.mkDerivation rec {
  pname = "git-extras";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "tj";
    repo = "git-extras";
    rev = version;
    sha256 = "sha256-e1UUAHXTRNgNWrYZuLGdrQIAD8WADmA2B9bVnDNidf8=";
  };

  postPatch = ''
    patchShebangs check_dependencies.sh
  '';

  nativeBuildInputs = [
    unixtools.column
    which
  ];

  dontBuild = true;

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/share"
  ];

  postInstall = ''
    # bash completion is already handled by make install
    install -D etc/git-extras-completion.zsh $out/share/zsh/site-functions/_git_extras
  '';

  meta = with lib; {
    homepage = "https://github.com/tj/git-extras";
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ cko SuperSandro2000 ];
  };
}
