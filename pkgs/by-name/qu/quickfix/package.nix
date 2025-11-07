{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "quickfix";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "quickfix";
    repo = "quickfix";
    rev = "v${version}";
    sha256 = "1fgpwgvyw992mbiawgza34427aakn5zrik3sjld0i924a9d17qwg";
  };

  patches = [
    # Improved C++17 compatibility
    (fetchpatch {
      url = "https://github.com/quickfix/quickfix/commit/a46708090444826c5f46a5dbf2ba4b069b413c58.diff";
      sha256 = "1wlk4j0wmck0zm6a70g3nrnq8fz0id7wnyxn81f7w048061ldhyd";
    })
    ./disableUnitTests.patch
  ];

  # autoreconfHook does not work
  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace bootstrap --replace-fail glibtoolize libtoolize
  '';

  preConfigure = ''
    ./bootstrap
  '';

  # More hacking out of the unittests
  preBuild = ''
    substituteInPlace Makefile --replace 'UnitTest++' ' '
  '';

  meta = with lib; {
    description = "C++ Fix Engine Library";
    homepage = "http://www.quickfixengine.org";
    license = licenses.free; # similar to BSD 4-clause
    maintainers = with maintainers; [ bhipple ];
    broken = stdenv.hostPlatform.isAarch64;
  };
}
