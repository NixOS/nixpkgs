{ stdenv, fetchgit, ruby, makeWrapper, git }:

stdenv.mkDerivation rec {
  name = "svn2git-20111206";

  src = fetchgit {
    url = https://github.com/nirvdrum/svn2git;
    rev = "5cd8d4b509affb66eb2dad50d7298c52b3b0d848";
    sha256 = "26aa17f68f605e958b623d803b4bd405e12d6c5d51056635873a2c59e4c7b9ca";
  };

  buildInputs = [ ruby makeWrapper ];

  buildPhase = "true";

  installPhase =
    ''
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
}
