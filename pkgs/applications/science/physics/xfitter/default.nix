{ lib
, stdenv
, fetchurl
, apfel
, apfelgrid
, applgrid
, blas
, ceres-solver
, cmake
, gfortran
, gsl
, lapack
, lhapdf
, libtirpc
, libyaml
, yaml-cpp
, pkg-config
, qcdnum
, root
, zlib
, memorymappingHook, memstreamHook
}:

stdenv.mkDerivation rec {
  pname = "xfitter";
  version = "2.2.0";

  src = fetchurl {
    name = "${pname}-${version}.tgz";
    url = "https://www.xfitter.org/xFitter/xFitter/DownloadPage?action=AttachFile&do=get&target=${pname}-${version}.tgz";
    sha256 = "sha256-ZHIQ5hOY+k0/wmpE0o4Po+RZ4MkVMk+bK1Rc6eqwwH0=";
  };

  patches = [
    # Avoid need for -fallow-argument-mismatch
    ./0001-src-GetChisquare.f-use-correct-types-in-calls-to-DSY.patch
  ];

  nativeBuildInputs = [ cmake gfortran pkg-config ];
  buildInputs =
    [ apfel blas ceres-solver lhapdf lapack libyaml root qcdnum gsl yaml-cpp zlib ]
    ++ lib.optionals ("5" == lib.versions.major root.version) [ apfelgrid applgrid ]
    ++ lib.optionals (stdenv.system == "x86_64-darwin") [ memorymappingHook memstreamHook ]
    ++ lib.optional (stdenv.hostPlatform.libc == "glibc") libtirpc
    ;

  NIX_CFLAGS_COMPILE = lib.optional (stdenv.hostPlatform.libc == "glibc") "-I${libtirpc.dev}/include/tirpc";
  NIX_LDFLAGS = lib.optional (stdenv.hostPlatform.libc == "glibc") "-ltirpc";

  # workaround wrong library IDs
  postInstall = lib.optionalString stdenv.isDarwin ''
    ln -sv "$out/lib/xfitter/"* "$out/lib/"
  '';

  meta = with lib; {
    description = "The xFitter project is an open source QCD fit framework ready to extract PDFs and assess the impact of new data";
    license     = licenses.gpl3;
    homepage    = "https://www.xfitter.org/xFitter";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
