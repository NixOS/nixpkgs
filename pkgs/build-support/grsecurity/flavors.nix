let
  mkOpts = ver: prio: sys: virt: swvirt: hwvirt:
    { config.priority               = prio;
      config.system                 = sys;
      config.virtualisationConfig   = virt;
      config.hardwareVirtualisation = hwvirt;
      config.virtualisationSoftware = swvirt;
    } // builtins.listToAttrs [ { name = ver; value = true; } ];
in
{
  # Stable kernels
  linux_grsec_stable_desktop =
    mkOpts "stable" "performance" "desktop" "host" "kvm" true;
  linux_grsec_stable_server  =
    mkOpts "stable" "security" "server" "host" "kvm" true;
  linux_grsec_stable_server_xen =
    mkOpts "stable" "security" "server" "guest" "xen" true;

  # Stable+vserver kernels - server versions only
  linux_grsec_vserver_server  =
    mkOpts "vserver" "security" "server" "host" "kvm" true;
  linux_grsec_vserver_server_xen =
    mkOpts "vserver" "security" "server" "guest" "xen" true;

  # Testing kernels
  linux_grsec_testing_desktop =
    mkOpts "testing" "performance" "desktop" "host" "kvm" true;
  linux_grsec_testing_server  =
    mkOpts "testing" "security" "server" "host" "kvm" true;
  linux_grsec_testing_server_xen =
    mkOpts "testing" "security" "server" "guest" "xen" true;
}