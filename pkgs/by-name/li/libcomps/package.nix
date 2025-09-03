{
  lib,
  check,
  cmake,
  doxygen,
  expat,
  fetchFromGitHub,
  libxml2,
  python3,
  sphinx,
  stdenv,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libcomps";
  version = "0.1.22";

  outputs = [
    "out"
    "dev"
    "py"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "libcomps";
    rev = version;
    hash = "sha256-zaUQbMYL9wIzqs3cQwPY1B2UZ7DwkksTxeFugol0FRk=";
  };

  patches = [
    ./fix-python-install-dir.patch
  ];

  postPatch = ''
    substituteInPlace libcomps/src/python/src/CMakeLists.txt \
      --replace "@PYTHON_INSTALL_DIR@" "$out/${python3.sitePackages}"
  '';

  nativeBuildInputs = [
    check
    cmake
    doxygen
    python3
    sphinx
  ];

  buildInputs = [
    expat
    libxml2
    zlib
  ];

  dontUseCmakeBuildDir = true;
  cmakeDir = "libcomps";

  postFixup = ''
    ls $out/lib
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  meta = with lib; {
    description = "Comps XML file manipulation library";
    homepage = "https://github.com/rpm-software-management/libcomps";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ katexochen ];
    platforms = platforms.unix;
  };
}
