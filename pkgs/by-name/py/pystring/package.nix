{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "pystring";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "pystring";
    rev = "v${version}";
    sha256 = "1w31pjiyshqgk6zd6m3ab3xfgb0ribi77r6fwrry2aw8w1adjknf";
  };

  patches = [
    (fetchpatch {
      name = "pystring-cmake-configuration.patch";
      url = "https://github.com/imageworks/pystring/commit/4f653fc35421129eae8a2c424901ca7170059370.patch";
      sha256 = "1hynzz76ff4vvmi6kwixsmjswkpyj6s4vv05d7nw0zscj4cdp8k3";
    })
  ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/imageworks/pystring/";
    description = "Collection of C++ functions which match the interface and behavior of python's string class methods using std::string";
    license = licenses.bsd3;
    maintainers = [ maintainers.rytone ];
    platforms = platforms.unix;
  };
}
