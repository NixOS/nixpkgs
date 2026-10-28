{
  quartus-prime-lite,
  supportedDevices ? [
    "Arria II"
    "Arria V"
    "Arria V GZ"
    "Arria 10"
    "Cyclone V"
    "Cyclone IV"
    "Cyclone 10 LP"
    "MAX II/V"
    "MAX 10 FPGA"
    "Stratix IV"
    "Stratix V"
  ],
  ...
}@args:

quartus-prime-lite.override (
  (removeAttrs args [
    "supportedDevices"
    "quartus-prime-lite"
  ])
  // {
    inherit
      supportedDevices
      ;
    variant = "standard";
  }
)
