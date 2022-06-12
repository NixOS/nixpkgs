{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, makeWrapper, perlPackages, libminc }:

stdenv.mkDerivation rec {
  pname = "mni_autoreg";
  version = "unstable-2017-09-22";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = "ab99e29987dc029737785baebf24896ec37a2d76";
    sha256 = "0axl069nv57vmb2wvqq7s9v3bfxwspzmk37bxm4973ai1irgppjq";
  };

  patches = [
    # Pull upstream workaround for -fno-common toolchains:
    #  https://github.com/BIC-MNI/mni_autoreg/pull/28
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/BIC-MNI/mni_autoreg/commit/06adfacbd84369ea3bcc4376596ac1c0f2e49af9.patch";
      sha256 = "004sdrbx9kcj1qqwjly6p03svakl0x2sbv83salyg63fv67jynx8";
    })
  ];

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ libminc ];
  propagatedBuildInputs = with perlPackages; [ perl GetoptTabular MNI-Perllib ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];
  # testing broken: './minc_wrapper: Permission denied' from Testing/ellipse0.mnc

  postFixup = ''
    for prog in autocrop mritoself mritotal xfmtool; do
      echo $out/bin/$prog
      wrapProgram $out/bin/$prog --prefix PERL5LIB : $PERL5LIB;
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/mni_autoreg";
    description = "Tools for automated registration using the MINC image format";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
