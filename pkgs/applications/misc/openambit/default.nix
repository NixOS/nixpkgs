{
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lib,
  libusb1,
  mkDerivation,
  python3,
  qtbase,
  qttools,
  udev,
  zlib,
}:

mkDerivation rec {
  pname = "openambit";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "openambitproject";
    repo = "openambit";
    rev = version;
    sha256 = "1074kvkamwnlkwdajsw1799wddcfkjh2ay6l842r0s4cvrxrai85";
  };

  patches = [
    # Pull upstream patch for -fno-common toolchain support:
    #   https://github.com/openambitproject/openambit/pull/244
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/openambitproject/openambit/commit/b6d97eab417977b6dbe355e0b071d0a56cc3df6b.patch";
      sha256 = "1p0dg902mlcfjvs01dxl9wv2b50ayp4330p38d14q87mn0c2xl5d";
    })
  ];

  nativeBuildInputs = [
    cmake
    qttools
  ];
  buildInputs = [
    libusb1
    python3
    qtbase
    udev
    zlib
  ];

  cmakeFlags = [ "-DCMAKE_INSTALL_UDEVRULESDIR=${placeholder "out"}/lib/udev/rules.d" ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/openambit --version

    runHook postInstallCheck
  '';

  postInstall = ''
    install -m755 -D $src/tools/openambit2gpx.py $out/bin/openambit2gpx

    mv -v $out/lib/udev/rules.d/libambit.rules \
          $out/lib/udev/rules.d/20-libambit.rules
  '';

  meta = with lib; {
    description = "Helps fetch data from Suunto Ambit GPS watches";
    homepage = "https://github.com/openambitproject/openambit/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
  };
}
