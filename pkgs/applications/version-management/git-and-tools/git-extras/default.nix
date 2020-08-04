{ stdenv, fetchzip, unixtools, which }:

stdenv.mkDerivation rec {
  pname = "git-extras";
  version = "6.0.0";

  src = fetchzip {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "0mxb3c5lb5n7c76bp10bw7bid564vjxi5f7cvzaj2ss93v5rr11g";
  };

  nativeBuildInputs = [ unixtools.column which ];

  dontBuild = true;

  preInstall = ''
    patchShebangs .
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    # bash completion is already handled by make install
    install -D etc/git-extras-completion.zsh $out/share/zsh/site-functions/_git_extras
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/tj/git-extras";
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt maintainers.cko ];
  };
}
