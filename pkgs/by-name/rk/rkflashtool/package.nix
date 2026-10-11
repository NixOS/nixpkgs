{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  libusb1,
  makeWrapper,
  pkg-config,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rkflashtool";
  version = "0-unstable-2025-09-30";

  src = fetchFromGitHub {
    owner = "linux-rockchip";
    repo = "rkflashtool";
    rev = "fc2181c577ef3fb1e821818dfd07e0dac0575b74";
    hash = "sha256-uXjMK07dIa/LUbaokLViJXQHkthGjpdXQLQEYN2v6VE=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "pkg-config" "$PKG_CONFIG"
  '';

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    udevCheckHook
  ];

  buildInputs = [ libusb1 ];

  makeFlags = [
    "CROSSPREFIX=${stdenv.cc.targetPrefix}"
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2207", MODE="0666"' > 51-rockchip.rules
    install -Dm444 51-rockchip.rules -t $out/lib/udev/rules.d

    for f in rkunsign rkparametersblock rkmisc rkpad rkparameters; do
      wrapProgram $out/bin/$f \
        --prefix PATH : ${lib.makeBinPath [ coreutils ]} \
        --prefix PATH : $out/bin
    done
  '';

  meta = {
    description = "Tools for flashing Rockchip devices";
    homepage = "https://github.com/linux-rockchip/rkflashtool";
    license = lib.licenses.bsd2;
    mainProgram = "rkflashtool";
    maintainers = with lib.maintainers; [ dmfrpro ];
    platforms = lib.platforms.linux;
  };
})
