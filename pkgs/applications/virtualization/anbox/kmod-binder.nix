{ stdenv, lib, fetchFromGitHub, fetchurl

, linuxPackages
, anbox
}:
let
  version = "2018-01-06";
in
stdenv.mkDerivation {
  name = "anbox-kmod-binder-${version}";
  src = anbox.src;

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
  sourceRoot = "source/kernel/binder";
  hardeningDisable = [ "pic" ];
  meta = {
    description = "Android containerization layer";
    homepage = "https://anbox.io/";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ lukeadams ];
    platforms = lib.platforms.linux;
  };
}
