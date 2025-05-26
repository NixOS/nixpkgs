{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  xercesc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libe57format";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "asmaloney";
    repo = "libE57Format";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bOuWh9Nkxva2v0M6+vnAya8EW/G3WQePxHakQt8T9NE=";
    fetchSubmodules = true; # for submodule-vendored libraries such as `gtest`
  };

  # Repository of E57 files used for testing.
  libE57Format-test-data_src = fetchFromGitHub {
    owner = "asmaloney";
    repo = "libE57Format-test-data";
    rev = "4960564a732c6444c50dfae5b2273e68837399cd";
    hash = "sha256-k26yVbYSQJ3EMgcpjm35N1OAxarFmfMvzfTN2Hdyu8c=";
  };

  CXXFLAGS = [
    # GCC 13: error: 'int16_t' has not been declared in 'std'
    "-include cstdint"
  ];

  patches = [
    # TODO: Remove with the next release: https://github.com/asmaloney/libE57Format/pull/299
    (fetchpatch {
      name = "libE57Format-Dont-force-warnings-as-errors-when-building-self.patch"; # https://github.com/apache/thrift/pull/2726
      url = "https://github.com/asmaloney/libE57Format/commit/66bb5af15937b4c10a7f412ca4d1673f42bbad28.patch";
      hash = "sha256-2cNURjMLP0TijYY5gbuWLE7H/PlMW936wAeOqJ/w9C0=";
    })

  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    xercesc
  ];

  cmakeFlags = [
    # See https://github.com/asmaloney/libE57Format/blob/9372bdea8db2cc0c032a08f6d655a53833d484b8/test/README.md
    (
      if finalAttrs.finalPackage.doCheck then
        "-DE57_TEST_DATA_PATH=${finalAttrs.libE57Format-test-data_src}"
      else
        "-DE57_BUILD_TEST=OFF"
    )
  ];

  doCheck = true;

  postCheck = ''
    ./testE57
  '';

  # The build system by default builds ONLY static libraries, and with
  # `-DE57_BUILD_SHARED=ON` builds ONLY shared libraries, see:
  #     https://github.com/asmaloney/libE57Format/issues/48
  #     https://github.com/asmaloney/libE57Format/blob/f657d470da5f0d185fe371c4c011683f6e30f0cb/CMakeLists.txt#L82-L89
  # We support building both by building statically and then
  # building an .so file here manually.
  # The way this is written makes this Linux-only for now.
  postInstall = ''
    cd $out/lib
    g++ -Wl,--no-undefined -shared -o libE57FormatShared.so -L. -Wl,-whole-archive -lE57Format -Wl,-no-whole-archive -lxerces-c
    mv libE57FormatShared.so libE57Format.so

    if [ "$dontDisableStatic" -ne "1" ]; then
      rm libE57Format.a
    fi
  '';

  meta = with lib; {
    description = "Library for reading & writing the E57 file format";
    homepage = "https://github.com/asmaloney/libE57Format";
    license = licenses.boost;
    maintainers = with maintainers; [
      chpatrick
      nh2
    ];
    platforms = platforms.linux; # because of the .so buiding in `postInstall` above
  };
})
