{ stdenv, fetchurl, qmake, zip }:

stdenv.mkDerivation rec {
  name = "UEFITool-${version}";
  version = "0.25.1";

  src = fetchurl {
    url = "https://github.com/LongSoft/UEFITool/archive/${version}.tar.gz";
    sha256 = "0bgffna9sbgr1nw517jv5lj5lppg9pany415gjzmd8gj0m28fvsw";
  };

  nativeBuildInputs = [ qmake zip ];

  enableParallelBuilding = true;

  qmakeFlags = [
    "QMAKE_CXXFLAGS+=-flto"
    "QMAKE_LFLAGS+=-flto"
    "CONFIG+=optimize_size"
    "-recursive" "subdirs.pro"
  ];

  # Subprojects use a bespoke layout, so create a meta-project to
  # build them all in one go.
  preConfigure = ''
    cat >subdirs.pro <<EOF
    TEMPLATE = subdirs
    SUBDIRS = uefitool uefipatch uefireplace
    uefitool.file = uefitool.pro
    uefipatch.file = UEFIPatch/uefipatch.pro
    uefireplace.file = UEFIReplace/uefireplace.pro
    EOF
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp UEFITool UEFIPatch/UEFIPatch UEFIReplace/UEFIReplace $out/bin
  '';

  meta = with stdenv.lib; {
    description = "UEFI firmware image viewer and editor";
    homepage = https://github.com/LongSoft/UEFITool;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ tadfisher ];
  };
}
