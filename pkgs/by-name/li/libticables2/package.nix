{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  autoreconfHook,
  glib,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libticables2";
  version = "1.3.6";
  src = fetchFromGitHub {
    owner = "debrouxl";
    repo = "tilibs";
    rev = "aae5bcf4a6b7c653eaf1d80c752e74eff042b4b5";
    hash = "sha256-W2SkOsqm3HJ3z6RHua5LQW6Mq1VQHGcouz0Cu/zENJE=";
  };

  sourceRoot = finalAttrs.src.name + "/libticables/trunk";

  patches = [
    (fetchpatch {
      name = "add-support-for-aarch64-macos-target-triple.patch";
      url = "https://github.com/debrouxl/tilibs/commit/ef41c51363b11521460f33e8c332db7b0a9ca085.patch";
      sha256 = "sha256-oTR1ACEZI0fjErpnFXTCnfLT1mo10Ypy0q0D8NOPNsM=";
      relative = "ticables/trunk";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libusb1
    glib
  ];

  configureFlags = [
    "--enable-libusb10"
  ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp ${./69-libsane.rules} $out/etc/udev/rules.d/69-libsane.rules
  '';

  meta = with lib; {
    changelog = "http://lpg.ticalc.org/prj_tilp/news.html";
    description = "This library is part of the TiLP framework";
    homepage = "http://lpg.ticalc.org/prj_tilp/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      siraben
      clevor
    ];
    platforms = with platforms; linux ++ darwin;
  };
})
