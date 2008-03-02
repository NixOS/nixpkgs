args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://fabrice.bellard.free.fr/qemu/qemu-0.9.0.tar.gz;
			sha256 = "1h85njd8xvn472yhcm92rjyzqjr719ab73rxwmz9cm2n6gwsq7s9";
		};

		buildInputs = [ SDL zlib which ];
		configureFlags = [];
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
		inherit src;
	};
}
