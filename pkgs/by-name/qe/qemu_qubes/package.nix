{ qemu, qubes-vmm-xen }:
qemu.override {
  xen = qubes-vmm-xen;
  xenSupport = true;
}
