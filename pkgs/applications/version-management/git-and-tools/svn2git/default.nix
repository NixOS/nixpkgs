{ stdenv, fetchurl, ruby, makeWrapper, git }:

let
  version = "2.4.0";
in
stdenv.mkDerivation {
  name = "svn2git-${version}";

  src = fetchurl {
    url = "https://github.com/nirvdrum/svn2git/archive/v${version}.tar.gz";
    sha256 = "0ly2vrv6q31n0xhciwb7a1ilr5c6ndyi3bg81yfp4axiypps7l41";
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
