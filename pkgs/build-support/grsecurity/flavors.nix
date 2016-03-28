let
  mkOpts = prio: sys: virt: swvirt: hwvirt:
    { config.priority               = prio;
      config.system                 = sys;
      config.virtualisationConfig   = virt;
      config.hardwareVirtualisation = hwvirt;
      config.virtualisationSoftware = swvirt;
    };
in
{
  desktop =
    mkOpts "performance" "desktop" "host" "kvm" true;
  server  =
    mkOpts "security" "server" "host" "kvm" true;
  server_xen =
    mkOpts "security" "server" "guest" "xen" true;
}
