{
  unstick,
  withQuesta ? true,
  supportedDevices ? [
    "Agilex common files"
    "Agilex 3"
    "Agilex 5"
    "Agilex 7"
    "Stratix 10"
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
  variant = "pro";
}
