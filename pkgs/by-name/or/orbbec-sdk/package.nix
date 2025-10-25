{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  gcc,
  libGL,
}:

stdenv.mkDerivation {
  pname = "OrbbecSDK";
  version = "1.10.27";

  src = fetchFromGitHub {
    owner = "orbbec";
    repo = "OrbbecSDK";
    tag = "v${version}";
    sha256 = "sha256-e4dVlMkjQ5GNMO02RiIcV/IPhwqf5o9wTTPTds9qzL0=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc
    stdenv.cc.cc.lib
    libGL
  ];

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d $out/include
    cp -r include/* $out/include
    cp -r lib/linux_x64/* $out/lib
    cp misc/scripts/99-obsensor-libusb.rules $out/lib/udev/rules.d/
  '';

  meta = {
    description = "Orbbec SDK v1&v2 Pre-Compiled";
    homepage = "https://github.com/orbbec/OrbbecSDK";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lachstec ];
    platforms = [ "x86_64-linux" ];
  };
}
