{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  msgpack-cxx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mmtf-cpp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "rcsb";
    repo = "mmtf-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8JrNobvekMggS8L/VORKA32DNUdXiDrYMObjd29wQmc=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ msgpack-cxx ];

  # Fix the build with msgpack-cxx ≥ 6.0.
  #
  # Upstream is unmaintained and does not plan to fix this; see
  # <https://github.com/rcsb/mmtf-cpp/issues/44>.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_package(msgpack)' 'find_package(msgpack-cxx)' \
      --replace-fail msgpackc msgpack-cxx
  '';

  meta = with lib; {
    description = "Library of exchange-correlation functionals with arbitrary-order derivatives";
    homepage = "https://github.com/rcsb/mmtf-cpp";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.sheepforce ];
  };
})
