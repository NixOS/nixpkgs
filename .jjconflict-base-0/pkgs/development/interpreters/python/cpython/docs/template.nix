# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "pythonMAJORMINOR-docs-TYPE";
  version = "VERSION";

  src = fetchurl {
    url = "URL";
    sha256 = "SHA";
  };
  installPhase = ''
    mkdir -p $out/share/doc/pythonMAJORMINOR
    cp -R ./ $out/share/doc/pythonMAJORMINOR/TYPE
  '';
  meta = {
    maintainers = [ ];
  };
}
