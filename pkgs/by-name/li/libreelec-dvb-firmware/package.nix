{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "libreelec-dvb-firmware";
  version = "1.5.0";

  src = fetchFromGitHub {
    repo = "dvb-firmware";
    owner = "LibreElec";
    rev = version;
    sha256 = "sha256-uEobcv5kqGxIOfSVVKH+iT7DHPF13OFiRF7c1GIUqtU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -rv firmware $out/lib
    find $out/lib \( -name 'README.*' -or -name 'LICEN[SC]E.*' -or -name '*.txt' \) | xargs rm

    runHook postInstall
  '';

  meta = {
    description = "DVB firmware from LibreELEC";
    homepage = "https://github.com/LibreELEC/dvb-firmware";
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with lib.maintainers; [ kittywitch ];
    platforms = lib.platforms.linux;
  };
}
