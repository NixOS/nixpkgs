{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "git-extras-${version}";
  version = "4.7.0";

  src = fetchurl {
    url = "https://github.com/tj/git-extras/archive/${version}.tar.gz";
    sha256 = "0pab4f5kmmcn333aswkgndf1fgilc41h8h0rk3lviz0yi8j59vaq";
  };

  dontBuild = true;

  installFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  postInstall = ''
    install -D etc/git-extras-completion.zsh $out/share/zsh/site-functions/_git_extras
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/tj/git-extras;
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.spwhitt maintainers.cko ];
  };
}
