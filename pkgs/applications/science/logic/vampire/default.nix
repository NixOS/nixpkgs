{ stdenv, fetchFromGitHub, fetchpatch, z3, zlib, git }:

stdenv.mkDerivation rec {
  version = "4.2.2";
  name = "vampire-${version}";

  src = fetchFromGitHub {
    owner = "vprover";
    repo = "vampire";
    rev = version;
    sha256 = "03dqjxr3cwz4h6sn9074kc6b6wjz12kpsvsi0mq2w0j5l9f8d80y";
    #fetchSubmodules = true;
    #leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];
  buildInputs = [ z3 zlib ];

  makeFlags = [ "vampire_z3_rel" "CC:=$(CC)" "CXX:=$(CXX)" ];

  patches = [
    # https://github.com/vprover/vampire/pull/54
    (fetchpatch {
      name = "fix-apple-cygwin-defines.patch";
      url = https://github.com/vprover/vampire/pull/54.patch;
      sha256 = "0i6nrc50wlg1dqxq38lkpx4rmfb3lf7s8f95l4jkvqp0nxa20cza";
    })
    # https://github.com/vprover/vampire/pull/55
    (fetchpatch {
      name = "fix-wait-any.patch";
      url = https://github.com/vprover/vampire/pull/55.patch;
      sha256 = "1pwfpwpl23bqsgkmmvw6bnniyvp5j9v8l3z9s9pllfabnfcrcz9l";
    })
    # https://github.com/vprover/vampire/pull/56
    (fetchpatch {
      name = "fenv.patch";
      url = https://github.com/vprover/vampire/pull/56.patch;
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

  meta = with stdenv.lib; {
    homepage = "https://vprover.github.io/";
    description = "The Vampire Theorem Prover";
    platforms = platforms.unix;
    license = licenses.unfree;
    maintainers = with maintainers; [ gebner ];
  };
}
