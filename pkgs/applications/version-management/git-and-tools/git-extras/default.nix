{ stdenv, fetchzip, unixtools, which }:

stdenv.mkDerivation rec {
  pname = "git-extras";
  version = "6.1.0";

  src = fetchzip {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "12ff9rhgqd71xm72r385hx0h8g75hz0ag0adzqcwfa54k0lhrrrz";
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
