{ lib }:
description: {
  homepage = "https://ceph.io/en/";
  inherit description;
  license = with lib.licenses; [
    lgpl21
    gpl2Only
    bsd3
    mit
    publicDomain
  ];
  maintainers = with lib.maintainers; [
    adev
    ak
    johanot
    krav
    nh2
    benaryorg
  ];
  platforms = [
    "x86_64-linux"
    "aarch64-linux"
  ];
}
