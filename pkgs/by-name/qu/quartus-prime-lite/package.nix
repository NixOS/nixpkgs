{
  unstick,
  withQuesta ? true,
  supportedDevices ? [
    "Arria II"
    "Cyclone V"
    "Cyclone IV"
    "Cyclone 10 LP"
    "MAX II/V"
    "MAX 10 FPGA"
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
  variant = "lite";
}
