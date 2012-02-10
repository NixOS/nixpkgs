{ stdenv, fetchgit, ruby, makeWrapper, git }:

stdenv.mkDerivation rec {
  name = "svn2git-2.2.0";

  src = fetchgit {
    url = https://github.com/nirvdrum/svn2git;
    rev = "db0769835e9d1d3ff324091a3bb7756200a09932";
    sha256 = "6d2f2acb9900e2aa8e608d3239b42f890f2334b622adb5ea33b2b4815a52efa2";
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
