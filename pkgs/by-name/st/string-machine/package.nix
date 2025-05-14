{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  boost,
  cairo,
  libGL,
  lv2,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "string-machine";
  version = "unstable-2020-01-20";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "string-machine";
    rev = "188082dd0beb9a3c341035604841c53675fe66c4";
    sha256 = "0l9xrzp3f0hk6h320qh250a0n1nbd6qhjmab21sjmrlb4ngy672v";
    fetchSubmodules = true;
  };

  patches = [
    # gcc-13 compatibility fix:
    #   https://github.com/jpcima/string-machine/pull/36
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/jpcima/string-machine/commit/e1f9c70da46e43beb2654b509bc824be5601a0a5.patch";
      hash = "sha256-eS28wBuFjbx2tEb9gtVRZXfK0w2o1RCFTouNf8Adq+k=";
    })
  ];

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    boost
    cairo
    libGL
    lv2
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    homepage = "https://github.com/jpcima/string-machine";
    description = "Digital model of electronic string ensemble instrument";
    maintainers = [ maintainers.magnetophon ];
    platforms = intersectLists platforms.linux platforms.x86;
    license = licenses.boost;
  };
}
