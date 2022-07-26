{ lib, stdenv, fetchFromGitHub, fetchpatch, z3, zlib }:

stdenv.mkDerivation rec {
  pname = "vampire";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "vprover";
    repo = "vampire";
    rev = "v${version}";
    sha256 = "0z71nxjak3ibp842r8iv37w1x3cbkrmjs88lpvxqb4sgrbyk38zd";
  };

  buildInputs = [ z3 zlib ];

  makeFlags = [ "vampire_z3_rel" "CC:=$(CC)" "CXX:=$(CXX)" ];

  patches = [
    # https://github.com/vprover/vampire/pull/54
    (fetchpatch {
      name = "fix-apple-cygwin-defines.patch";
      url = "https://github.com/vprover/vampire/pull/54.patch";
      sha256 = "0i6nrc50wlg1dqxq38lkpx4rmfb3lf7s8f95l4jkvqp0nxa20cza";
    })
    # https://github.com/vprover/vampire/pull/55
    (fetchpatch {
      name = "fix-wait-any.patch";
      url = "https://github.com/vprover/vampire/pull/55.patch";
      sha256 = "1pwfpwpl23bqsgkmmvw6bnniyvp5j9v8l3z9s9pllfabnfcrcz9l";
    })
    # https://github.com/vprover/vampire/pull/56
    (fetchpatch {
      name = "fenv.patch";
      url = "https://github.com/vprover/vampire/pull/56.patch";
      sha256 = "0xl3jcyqmk146mg3qj5hdd0pbja6wbq3250zmfhbxqrjh40mm40g";
    })
  ];

  enableParallelBuilding = true;

  fixupPhase = ''
    rm -rf z3
  '';

  installPhase = ''
    install -m0755 -D vampire_z3_rel* $out/bin/vampire
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://vprover.github.io/";
    description = "The Vampire Theorem Prover";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ gebner ];
  };
}
