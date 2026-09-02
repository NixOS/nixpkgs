{
  stdenvNoCC,
  lib,
  soapysdr,
  limesuite,
  soapyairspy,
  soapyaudio,
  soapybladerf,
  soapyhackrf,
  soapyplutosdr,
  soapyremote,
  soapyrtlsdr,
  soapyuhd,
  python ? null,
  usePython ? false,
}:

soapysdr.override {
  extraPackages = [
    limesuite
    soapyairspy
    soapyaudio
    soapybladerf
    soapyhackrf
    soapyplutosdr
    soapyremote
    soapyrtlsdr
  ]
  ++ (lib.optionals stdenvNoCC.hostPlatform.isLinux [
    soapyuhd
  ]);

  inherit python usePython;
}
