{
  lvm2,
}:

lvm2.override {
  enableDmeventd = true;
  enableCmdlib = true;
  enableVDO = true;
}
