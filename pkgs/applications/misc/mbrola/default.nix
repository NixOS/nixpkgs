{ stdenv, fetchurl, unzip, bash, patchelf, stdenv_32bit, makeWrapper, gcc_multi }:

let
	TCTS = "https://tcts.fpms.ac.be/synthesis/mbrola";

	# debian provides manpage and libstrongexit.so
	# read https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=856331;msg=5
	deb = fetchurl {
		url = "http://http.debian.net/debian/pool/non-free/m/mbrola/mbrola_3.01h+2-3.debian.tar.xz";
		sha256 = "16m99l5xscq20vishdk4y9svsmzfdw3f54ifjdhikgpsw2blbnq0";
	};

	binaries = rec {
		i686-linux = fetchurl  {
			url = "${TCTS}/bin/pclinux/mbr301h.zip";
			sha256 = "0vlxb2jpvps4nbgm9dfglik0973bf4fpr0v8rrpj08y8jynjyh6z";
		};
		x86_64-linux = i686-linux; # mbrola_AMD_Linux.zip is broken, we have to use 32bits
		powerpc-linux = i686-linux;
	};

	voicefr1 = fetchurl {
		url = "${TCTS}/dba/fr1/fr1-990204.zip";
		sha256 = "0c9qza71l6in4c6rgl5pqhy7x4as9fcfyb6sxqy3rxaf547w7d4f";
	};

	voicefr2 = fetchurl {
		url = "${TCTS}/dba/fr2/fr2-980806.zip";
		sha256 = "01qk4wq20gap1inj43igy1llg3rq685vdgrvsflhvl3fcxhn70rv";
	};
in

stdenv.mkDerivation rec {

pname = "mbrola";
name = "${pname}-${version}";
version = "3.0.1h";

src = deb;
binary = binaries."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");

buildInputs = [ unzip ];
nativeBuildInputs = [ patchelf makeWrapper gcc_multi ];

postUnpack = ''

	pushd $sourceRoot
	unzip ${binary}
	unzip ${voicefr1}
	unzip ${voicefr2}
	popd
'';

buildPhase = ''
	case "${stdenv.system}" in
		i686*)
			cp mbrola-linux-i386 mbrola
			;;
		x86_64*)
			cp mbrola-linux-i386 mbrola
			gcc -m32 strongexit/strongexit.c -o libstrongexit.so -shared -fPIC
			patchelf --set-interpreter                            \
			${stdenv_32bit.cc.libc.out}/lib/32/ld-linux.so.2  \
			mbrola
		;;
		powerpc*)
			cp mbrola302b-linux-ppc mbrola
		;;
		sparc)
			cp mbrola-SuSElinux-ultra1.dat mbrola
		;;
		alpha)
			cp mbrola-linux-alpha mbrola
		;;
		*)
			echo "mbrola binary not available on this architecture."
			exit 1
	esac
'';

	installPhase = ''
		mkdir -p $out/{bin,share/mbrola/voices}
		cp mbrola $out/bin/mbrola

		mkdir -p $out/share/man/man1
		cp mbrola.1 $out/share/man/man1

		mkdir -p $out/lib/
		cp libstrongexit.so $out/lib/
		wrapProgram $out/bin/mbrola \
		--prefix LD_PRELOAD : "$out/lib/libstrongexit.so"

		for voice in ??[0-9]; do
		cp -a $voice $out/share/mbrola/voices
		done
	'';

	meta = with stdenv.lib; {
		homepage = https://tcts.fpms.ac.be/synthesis/mbrola.html;
		description = "Speech synthesizer based on the concatenation of diphones";
		license = licenses.unfree; #MBROLA
		maintainers = [ maintainers.genesis ];
		platforms = [ "x86_64-linux" ];
	};
}
