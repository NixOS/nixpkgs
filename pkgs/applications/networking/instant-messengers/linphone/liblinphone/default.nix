{
  lib,
  bc-soci,
  belcard,
  belle-sip,
  doxygen,
  jsoncpp,
  libxml2,
  lime,
  mediastreamer2,
  python3,
  sqlite,
  xercesc,
  zxing-cpp,
  mkLinphoneDerivation,
}:
mkLinphoneDerivation {
  pname = "liblinphone";

  cmakeFlags = [
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
    "-DENABLE_STRICT=NO" # Do not build with -Werror

    # normally set by a cmake module, but
    # we need to disable it to prevent downstream link errors
    "-DJsonCPP_TARGET=jsoncpp"
  ];

  buildInputs = [
    # Made by BC
    belcard
    belle-sip
    lime
    mediastreamer2

    # Vendored by BC
    bc-soci

    libxml2
    sqlite
    xercesc
    zxing-cpp
  ];

  propagatedBuildInputs = [
    jsoncpp
  ];

  nativeBuildInputs = [
    doxygen
    (python3.withPackages (ps: [
      ps.pystache
      ps.six
      ps.pyturbojpeg
    ]))
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail JsonCPP jsoncpp
  '';

  preConfigure = ''
    rm cmake/FindJsonCPP.cmake
  '';

  strictDeps = true;

  # Some grammar files needed to be copied too from some dependencies. I suppose
  # if one define a dependency in such a way that its share directory is found,
  # then this copying would be unnecessary. Instead of actually copying these
  # files, create a symlink.
  postInstall = ''
    mkdir -p $out/share/belr/grammars
    ln -s ${belcard}/share/belr/grammars/* $out/share/belr/grammars/
  '';

  meta = {
    description = "Library for SIP calls and instant messaging";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
  };
}
