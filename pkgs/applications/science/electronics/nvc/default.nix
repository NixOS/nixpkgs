{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, check
, flex
, pkg-config
, which
, elfutils
, libelf
, libffi
, llvm
, zlib
}:

stdenv.mkDerivation rec {
  pname = "nvc";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "nickg";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-hsoEAFSXI2bvzZV33jdg1849fipPQlUu3MZVvht54fI=";
  };

  patches = [
    # TODO: remove me on next release
    (fetchpatch {
      url = "https://github.com/nickg/nvc/commit/c857e16c33851f8a5386b97bc0dada2836b5db83.patch";
      hash = "sha256-rvZHI1iQXT9zLpCugg5mGmMZBRbTe9PSHtDG7FVZ67Q=";
    })
  ];

  # TODO: recheck me on next release
  postPatch = lib.optionalString stdenv.isLinux ''
    sed -i "/vhpi4/d" test/regress/testlist.txt
  '';

  nativeBuildInputs = [
    autoreconfHook
    check
    flex
    pkg-config
    which
  ];

  buildInputs = [
    libffi
    llvm
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    elfutils
  ] ++ lib.optionals (!stdenv.isLinux) [
    libelf
  ];

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  configureFlags = [
    "--enable-vhpi"
    "--disable-lto"
  ];

  doCheck = true;

  meta = with lib; {
    description = "VHDL compiler and simulator";
    homepage = "https://www.nickg.me.uk/nvc/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
