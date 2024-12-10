{
  lib,
  stdenv,
  fetchFromGitea,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:
let
  generic =
    {
      version,
      pname,
      src,
      meta,
    }:
    stdenv.mkDerivation {
      inherit version pname src;
      nativeBuildInputs = [
        pkg-config
        cmake
      ];
      propagatedBuildInputs = [ libusb1 ];

      cmakeFlags = lib.optionals stdenv.isLinux [
        "-DINSTALL_UDEV_RULES=ON"
        "-DWITH_RPC=ON"
      ];

      postPatch = ''
        substituteInPlace CMakeLists.txt \
          --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d" \
          --replace "VERSION_INFO_PATCH_VERSION git" "VERSION_INFO_PATCH_VERSION ${lib.versions.patch version}"

        substituteInPlace rtl-sdr.rules \
          --replace 'MODE:="0666"' 'ENV{ID_SOFTWARE_RADIO}="1", MODE="0660", GROUP="plugdev"'
      '';

      meta = with lib; {
        inherit (meta) longDescription homepage;
        description = "Software to turn the RTL2832U into a SDR receiver";
        license = licenses.gpl2Plus;
        maintainers = with maintainers; [
          bjornfor
          skovati
          Tungsten842
        ];
        platforms = platforms.unix;
        mainProgram = "rtl_sdr";
      };
    };
in
{
  rtl-sdr-osmocom = generic rec {
    pname = "rtl-sdr-osmocom";
    version = "2.0.1";

    src = fetchFromGitea {
      domain = "gitea.osmocom.org";
      owner = "sdr";
      repo = "rtl-sdr";
      rev = "v${version}";
      hash = "sha256-+RYSCn+wAkb9e7NRI5kLY8a6OXtJu7QcSUht1R6wDX0=";
    };
    meta = {
      longDescription = "Rtl-sdr library by the Osmocom project";
      homepage = "https://gitea.osmocom.org/sdr/rtl-sdr";
    };
  };

  rtl-sdr-librtlsdr = generic rec {
    pname = "rtl-sdr-librtlsdr";
    version = "0.9.0";

    src = fetchFromGitHub {
      owner = "librtlsdr";
      repo = "librtlsdr";
      rev = "v${version}";
      hash = "sha256-I1rbywQ0ZBw26wZdtMBkfpj7+kv09XKrrcoDuhIkRmw=";
    };
    meta = {
      longDescription = ''
        Fork of the rtl-sdr library by the Osmocom project. A list of differences
        can be found here: https://github.com/librtlsdr/librtlsdr/blob/master/README_improvements.md
      '';
      homepage = "https://github.com/librtlsdr/librtlsdr";
    };
  };

  rtl-sdr-blog = generic rec {
    pname = "rtl-sdr-blog";
    version = "1.3.5";

    src = fetchFromGitHub {
      owner = "rtlsdrblog";
      repo = "rtl-sdr-blog";
      rev = version;
      hash = "sha256-7FpT+BoQ2U8KiKwX4NfEwrO3lMBti7RX8uKtT5dFH8M=";
    };
    meta = {
      longDescription = ''
        Fork of the rtl-sdr library by the Osmocom project. A list of differences
        can be found here: https://github.com/rtlsdrblog/rtl-sdr-blog/blob/master/README
      '';
      homepage = "https://github.com/rtlsdrblog/rtl-sdr-blog";
    };
  };

}
