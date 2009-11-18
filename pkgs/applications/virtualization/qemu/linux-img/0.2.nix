
args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
			url = [ http://fabrice.bellard.free.fr/qemu/linux-0.2.img.bz2 http://bellard.org/qemu/linux-0.2.img.bz2];
			sha256 = "08xlwy1908chpc4fsqy2v13zi25dapk0ybrd43fj95v67kdj5hj1";
		};
		buildInputs = [];
		configureFlags = [];
	};
	in with localDefs;
let 
doCopy = fullDepEntry ("
  ensureDir \$out/share/qemu-images
  cp linux-0.2.img \$out/share/qemu-images/
") [minInit doUnpack defEnsureDir];
in
stdenv.mkDerivation rec {
	name = "QEmu-Linux-Image-0.2";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doCopy doForceShare doPropagate]);
	meta = {
		description = "Qemu sample image.";
		inherit src;
	};
}
