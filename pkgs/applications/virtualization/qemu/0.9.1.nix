args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://fabrice.bellard.free.fr/qemu/qemu-0.9.1.tar.gz;
			sha256 = "199mb12w141yh2afzznh539jsip4h79kfsxwaj1xhzfwljsd0mj7";
		};

		buildInputs = [ SDL zlib which ];
		configureFlags = [ ];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
let 
preConfigure = FullDepEntry ("
  gcc --version
") [minInit];
in
stdenv.mkDerivation rec {
	name = "qemu-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [ preConfigure doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
		QEmu processor emulator.
";
	};
}
