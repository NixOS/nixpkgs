{ lib, stdenv, fetchFromGitHub, ruby, makeWrapper, git }:

stdenv.mkDerivation rec {
  pname = "svn2git";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "nirvdrum";
    repo = "svn2git";
    rev = "v${version}";
    sha256 = "sha256-w649l/WO68vYYxZOBKzI8XhGFkaSwWx/O3oVOtnGg6w=";
  };

  nativeBuildInputs = [ ruby makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r lib $out/

    mkdir -p $out/bin
    substituteInPlace bin/svn2git --replace '/usr/bin/env ruby' ${ruby}/bin/ruby
    cp bin/svn2git $out/bin/
    chmod +x $out/bin/svn2git

    wrapProgram $out/bin/svn2git \
      --set RUBYLIB $out/lib \
      --prefix PATH : ${git}/bin
  '';

  meta = {
    homepage = "https://github.com/nirvdrum/svn2git";
    description = "Tool for importing Subversion repositories into git";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
