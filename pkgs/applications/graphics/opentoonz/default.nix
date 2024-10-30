{ boost
, cmake
, fetchFromGitHub
, libglut
, freetype
, glew
, libjpeg
, libmypaint
, libpng
, libusb1
, lz4
, xz
, lzo
, openblas
, opencv
, pkg-config
, qtbase
, qtmultimedia
, qtscript
, qtserialport
, lib
, stdenv
, superlu
, wrapQtAppsHook
, libtiff
, zlib
}:
let
  libtiff-ver = "4.0.3"; # The version in thirdparty/tiff-*
  opentoonz-ver = "1.7.1";

  src = fetchFromGitHub {
    owner = "opentoonz";
    repo = "opentoonz";
    rev = "v${opentoonz-ver}";
    hash = "sha256-5iXOvh4QTv+G0fjEHU62u7QCee+jbvKhK0+fQXbdJis=";
  };

  opentoonz-opencv = opencv.override {
    inherit libtiff;
  };

  opentoonz-libtiff = stdenv.mkDerivation {
    pname = "libtiff";
    version = "${libtiff-ver}-opentoonz";

    inherit src;
    outputs = [ "bin" "dev" "out" "man" "doc" ];

    nativeBuildInputs = [ pkg-config ];
    propagatedBuildInputs = [ zlib libjpeg xz ];

    postUnpack = ''
      sourceRoot="$sourceRoot/thirdparty/tiff-${libtiff-ver}"
    '';

    # opentoonz uses internal libtiff headers
    postInstall = ''
      cp libtiff/{tif_config,tif_dir,tiffiop}.h $dev/include
    '';

    meta = libtiff.meta // {
      knownVulnerabilities = [
        ''
          Do not open untrusted files with Opentoonz:
          Opentoonz uses an old custom fork of tibtiff from 2012 that is known to
          be affected by at least these 50 vulnerabilities:
            CVE-2012-4564 CVE-2013-4232 CVE-2013-4243 CVE-2013-4244 CVE-2014-8127
            CVE-2014-8128 CVE-2014-8129 CVE-2014-8130 CVE-2014-9330 CVE-2015-1547
            CVE-2015-8781 CVE-2015-8782 CVE-2015-8783 CVE-2015-8784 CVE-2015-8870
            CVE-2016-3620 CVE-2016-3621 CVE-2016-3623 CVE-2016-3624 CVE-2016-3625
            CVE-2016-3631 CVE-2016-3632 CVE-2016-3633 CVE-2016-3634 CVE-2016-3658
            CVE-2016-3945 CVE-2016-3990 CVE-2016-3991 CVE-2016-5102 CVE-2016-5314
            CVE-2016-5315 CVE-2016-5316 CVE-2016-5318 CVE-2016-5319 CVE-2016-5321
            CVE-2016-5322 CVE-2016-5323 CVE-2016-6223 CVE-2016-9453 CVE-2016-9532
            CVE-2017-9935 CVE-2017-9937 CVE-2018-10963 CVE-2018-5360
            CVE-2019-14973 CVE-2019-17546 CVE-2020-35521 CVE-2020-35522
            CVE-2020-35523 CVE-2020-35524
          More info at https://github.com/opentoonz/opentoonz/issues/4193
        ''
      ];
      maintainers = with lib.maintainers; [ chkno ];
    };
  };
in
stdenv.mkDerivation {
  inherit src;

  pname = "opentoonz";
  version = opentoonz-ver;

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  buildInputs = [
    boost
    libglut
    freetype
    glew
    libjpeg
    libmypaint
    libpng
    opentoonz-libtiff
    libusb1
    lz4
    xz
    lzo
    openblas
    opentoonz-opencv
    qtbase
    qtmultimedia
    qtscript
    qtserialport
    superlu
  ];

  postUnpack = "sourceRoot=$sourceRoot/toonz";

  cmakeDir = "../sources";
  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DTIFF_INCLUDE_DIR=${opentoonz-libtiff.dev}/include"
    "-DTIFF_LIBRARY=${opentoonz-libtiff.out}/lib/libtiff.so"
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
  ];

  postInstall = ''
    sed -i '/cp -r .*stuff/a\    chmod -R u+w $HOME/.config/OpenToonz/stuff' $out/bin/opentoonz
  '';

  meta = {
    description = "Full-featured 2D animation creation software";
    homepage = "https://opentoonz.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chkno ];
  };
}
