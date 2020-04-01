{ stdenv, fetchFromGitHub, boost, cairo, lv2, pkg-config }:

stdenv.mkDerivation rec {
  pname = "string-machine";
  version = "unstable-2020-01-20";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "188082dd0beb9a3c341035604841c53675fe66c4";
    sha256 = "0l9xrzp3f0hk6h320qh250a0n1nbd6qhjmab21sjmrlb4ngy672v";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    boost cairo lv2
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jpcima/string-machine";
    description = "Digital model of electronic string ensemble instrument";
    maintainers = [ maintainers.magnetophon ];
    platforms = intersectLists platforms.linux platforms.x86;
    license = licenses.boost;
  };
}
