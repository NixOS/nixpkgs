{ stdenv, fetchurl, ruby, makeWrapper, git }:

let
  version = "2.2.2";
in
stdenv.mkDerivation {
  name = "svn2git-${version}";

  src = fetchurl {
    url = "https://github.com/nirvdrum/svn2git/archive/v${version}.tar.gz";
    sha256 = "14zinkpgybz15jvbfw0sb432w6f5w4sa5pdqycjwva8v8lxqn9mh";
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

  meta = {
    homepage = https://github.com/nirvdrum/svn2git;
    description = "Ruby tool for importing existing svn projects into git";
    license = stdenv.lib.licenses.mit;

    maintainers = [ stdenv.lib.maintainers.the-kenny ];
  };
}
