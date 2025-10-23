{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  expat,
  curl,
  fftw,
}:

stdenv.mkDerivation rec {
  pname = "libofa";
  version = "0.9.3";
  deb_patch = "5";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/musicip-libofa/${pname}-${version}.tar.gz";
    sha256 = "184ham039l7lwhfgg0xr2vch2xnw1lwh7sid432mh879adhlc5h2";
  };

  debian_patches = fetchzip {
    url = "mirror://debian/pool/main/libo/libofa/libofa_${version}-${deb_patch}.debian.tar.gz";
    hash = "sha256-tENhXSRcUP1PKm35IJyLUEEROze8UzxJzRx3VNAqo40=";
  };

  patches = [
    "${debian_patches}/patches/01_gcc41.diff"
    "${debian_patches}/patches/02_example-open.diff"
    "${debian_patches}/patches/03_example-size_type.diff"
    "${debian_patches}/patches/04_libofa.pc-deps.diff"
    "${debian_patches}/patches/05_gcc43.diff"
    "${debian_patches}/patches/06_gcc44.diff"
    "${debian_patches}/patches/fix_ftbfs.diff"
    "${debian_patches}/patches/fix-ftbfs-gcc4.7.diff"
  ];

  outputs = [
    "out"
    "dev"
  ];

  setOutputFlags = false;

  preConfigure = ''
    configureFlagsArray=(--includedir=$dev/include --libdir=$out/lib)
  '';

  propagatedBuildInputs = [
    expat
    curl
    fftw
  ];

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/musicip-libofa/";
    description = "Library Open Fingerprint Architecture";
    longDescription = ''
      LibOFA (Library Open Fingerprint Architecture) is an open-source audio
      fingerprint created and provided by MusicIP'';
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
