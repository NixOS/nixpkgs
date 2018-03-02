{ stdenv, lib, fetchFromGitHub
, linuxPackages
}:
let
  version = "2018-01-06";
in
stdenv.mkDerivation {
  name = "anbox-kmod-ashmem-${version}";
  src = fetchFromGitHub {
    owner = "anbox";
    repo = "anbox";
    rev = "da3319106e6f568680017592aecdee34f0e407ac";
    sha256 = "0mgc6gp1km12qnshvsr26zn8bdd9gdix2s9xab594vq06ckznysd";
  };

  nativeBuildInputs = [ ];
  buildInputs = [
    linuxPackages.kernel.dev
  ];
  patchPhase = ''
    mkdir -p $out/kmod
  '';
  makeFlags = [
    "KERNEL_SRC=${linuxPackages.kernel.dev}/lib/modules/${linuxPackages.kernel.dev.version}/build"
    "DESTDIR=\${out}/kmod"
  ];
  sourceRoot = "source/kernel/ashmem";
  hardeningDisable = [ "pic" ];
  meta = {
    description = "Android containerization layer";
    homepage = "https://anbox.io/";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ lukeadams ];
    platforms = lib.platforms.linux;
  };
}
