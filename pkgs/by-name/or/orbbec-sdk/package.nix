{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  gcc,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "OrbbecSDK";
  version = "1.10.27";

  src = fetchFromGitHub {
    owner = "orbbec";
    repo = "OrbbecSDK";
    tag = "v${version}";
    hash = "sha256-e4dVlMkjQ5GNMO02RiIcV/IPhwqf5o9wTTPTds9qzL0=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc
    (lib.getLib stdenv.cc.cc)
    libGL
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/udev/rules.d $out/include
    cp -r include/* $out/include
    cp -r lib/linux_x64/* $out/lib
    cp misc/scripts/99-obsensor-libusb.rules $out/lib/udev/rules.d/

    runHook postInstall
  '';

  meta = {
    description = "Orbbec SDK v1&v2 Pre-Compiled";
    homepage = "https://github.com/orbbec/OrbbecSDK";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lachstec ];
    platforms = [ "x86_64-linux" ];
  };
}
