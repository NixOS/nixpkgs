{
  quartus-prime-lite,
  supportedDevices ? [
    "Agilex common files"
    "Agilex 3"
    "Agilex 5"
    "Agilex 7"
    "Arria 10"
    "Cyclone 10 GX"
    "Stratix 10"
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
    variant = "pro";
  }
)
