
args : with args; with builderDefs {src="";} null;
	let localDefs = builderDefs (rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = ftp://ftp.ru.debian.org/debian/pool/main/p/psi/psi_0.11.orig.tar.gz;
			sha256 = "1rgjahngari4pwhi0zz9mricaaqxkk8ry8w6s1vgsq3zwa2l5x57";
		};

		buildInputs = [aspell qt zlib sox openssl libX11 xproto 
			libSM libICE];
		configureFlags = [" --with-zlib-inc=${zlib}/include "
			" --with-openssl-inc=${openssl}/include "
		];
	}) args null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "psi-"+version;
	MAKE="make";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			["doConfigure" "doMakeInstall" doForceShare doPropagate]);
	meta = {
		description = "
		Psi, an XMPP (Jabber) client.
";
		inherit src;
	};
}

