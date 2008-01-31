args: with args;
let
	flacFun = version: hash:
	stdenv.mkDerivation rec {
		name = "flac-${version}";
		src = fetchurl ({
			url = "http://downloads.xiph.org/releases/flac/${name}.tar.gz";
		} // hash);
		buildInputs = [libogg];
    meta = {
      homepage = http://flac.sourceforge.net;
    };
	};
in
stdenv.lib.listOfListsToAttrs [
	[ "default" (flacFun "1.2.1" { sha256 = "1pry5lgzfg57pga1zbazzdd55fkgk3v5qy4axvrbny5lrr5s8dcn"; }) ]
	[ "1.2.1" (flacFun "1.2.1" { sha256 = "1pry5lgzfg57pga1zbazzdd55fkgk3v5qy4axvrbny5lrr5s8dcn"; }) ]
	[ "1.1.2" (flacFun "1.1.2" { md5 = "2bfc127cdda02834d0491ab531a20960"; }) ]
]
