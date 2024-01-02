{ lib
, stdenv
, fetchFromGitea
, cmake
, pkg-config
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "rtl-sdr-osmocom";
  version = "2.0.1";

  src = fetchFromGitea {
    domain = "gitea.osmocom.org";
    owner = "sdr";
    repo = "rtl-sdr";
    rev = "v${version}";
    hash = "sha256-+RYSCn+wAkb9e7NRI5kLY8a6OXtJu7QcSUht1R6wDX0=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '/etc/udev/rules.d' "$out/etc/udev/rules.d" \
      --replace "VERSION_INFO_PATCH_VERSION git" "VERSION_INFO_PATCH_VERSION ${lib.versions.patch version}"

    substituteInPlace rtl-sdr.rules \
      --replace 'MODE:="0666"' 'ENV{ID_SOFTWARE_RADIO}="1", MODE="0660", GROUP="plugdev"'
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  propagatedBuildInputs = [ libusb1 ];

  cmakeFlags = lib.optionals stdenv.isLinux [
    "-DINSTALL_UDEV_RULES=ON"
    "-DWITH_RPC=ON"
  ];

  meta = with lib; {
    description = "Software to turn the RTL2832U into a SDR receiver";
    longDescription = ''
    This packages the rtl-sdr library by the Osmocom project. This is the upstream codebase of the unsuffixed "rtl-sdr" package, which is a downstream fork. A list of differences can be found here:
    https://github.com/librtlsdr/librtlsdr/blob/master/README_improvements.md

    The Osmocom upstream has a regular release schedule, so this package will likely support newer SDR dongles. It should be compatible with most software that currently depends on the "rtl-sdr" nixpkg, but comptabiliy should be manually confirmed.
    '';
    homepage = "https://gitea.osmocom.org/sdr/rtl-sdr";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ skovati ];
    platforms = platforms.unix;
    mainProgram = "rtl_sdr";
  };
}
