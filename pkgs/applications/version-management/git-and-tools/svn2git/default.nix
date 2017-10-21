{ stdenv, fetchurl, ruby, makeWrapper, git }:

let
  version = "2.3.2";
in
stdenv.mkDerivation {
  name = "svn2git-${version}";

  src = fetchurl {
    url = "https://github.com/nirvdrum/svn2git/archive/v${version}.tar.gz";
    sha256 = "1484mpcabqf9kr6xdpdgb1npkqav1bcah3w5lxj2djjx4bjf2g3y";
  };

  buildInputs = [ ruby makeWrapper ];

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
    homepage = https://github.com/nirvdrum/svn2git;
    description = "Tool for importing Subversion repositories into git";
    license = stdenv.lib.licenses.mit;

    maintainers = [ stdenv.lib.maintainers.the-kenny ];
    platforms = stdenv.lib.platforms.unix;
  };
}
