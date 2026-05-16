{ stdenv
, lib
, dpkg
, fetchurl
, icu
, remarkable2-toolchain
, fontconfig
, vscode-extensions
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
    pname = "slithin";
	version = "1.0.13.0";
    src = fetchurl {
      url = "https://github.com/furesoft/Slithin/releases/download/${version}/Slithin.${version}.linux-x64.deb";
      sha512 = "14g32h3b8vk1qlxm2jvy68w3hbcgbwas027kx0pklcdp407kq54gid0spmn0c2cg9q6bqlbkg6kzfq300pq4lf7qd6b2xmfm9ykg8p0";
    };

	nativeBuildInputs = [
	autoPatchelfHook
	];

	unpackCmd = ''
    mkdir ./unpack
    ${dpkg}/bin/dpkg-deb -x $curSrc ./unpack
	'';

	buildInputs = [
    stdenv.cc.cc.lib
	fontconfig.lib
	vscode-extensions.ms-python.python.out
  	];

	runtimeDependencies = [
	icu
	];

	installPhase = ''
    mkdir -p $out
    mv usr $out/usr
	'';

	meta = {
    homepage = "https://github.com/furesoft/Slithin/";
    description = "Slithin is a forever free, cross-platform managenment tool for Remarkable Devices.";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3;
  	};
}
