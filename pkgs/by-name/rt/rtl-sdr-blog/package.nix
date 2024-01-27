{ stdenv
, fetchFromGitHub
, pkg-config
, cmake
, libusb1
, lib
}:

stdenv.mkDerivation rec {
  pname = "rtl-sdr-blog";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "rtlsdrblog";
    repo = pname;
    rev = "V${version}";
    hash = "sha256-4Qeawd8V68j9Gfw+AgLXHhiiTpyJM1/eb16AZCTa0Vc=";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  propagatedBuildInputs = [ libusb1 ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d" \
      --replace "VERSION_INFO_PATCH_VERSION git" "VERSION_INFO_PATCH_VERSION ${lib.versions.patch version}"
  '';

  cmakeFlags = lib.optionals stdenv.isLinux [
    "-DINSTALL_UDEV_RULES=ON"
    "-DWITH_RPC=ON"
  ];

  meta = with lib; {
    description = "Modified Osmocom drivers with enhancements for RTL-SDR Blog V3 and V4 units";
    homepage = "https://github.com/rtlsdrblog/rtl-sdr-blog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bddvlpr ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
