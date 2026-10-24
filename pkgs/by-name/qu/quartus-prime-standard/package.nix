{
  unstick,
  withQuesta ? true,
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
  extraProfile ? "",
  quartus-prime,
}:
quartus-prime.override {
  inherit
    extraProfile
    supportedDevices
    unstick
    withQuesta
    ;
  variant = "standard";
}
