{
  lib,
  libvirt,
  fetchFromGitHub,
  mountPath ? "/run/wrappers/bin/mount",
  qubes-vmm-xen,
}:
let
  inherit (lib) optionalString;
  versionPatches = "10.5.0";
  versionSuffix = "1";
  patches = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-core-libvirt";
    rev = "refs/tags/v${versionPatches}-${versionSuffix}";
    hash = "sha256-6c7H2ulsMXoc8U3EbZyVONEptaoAdW5VEhetqQ2DskY=";
  };
  patchSeries = ''
    0001-conf-add-script-attribute-to-disk-specification.patch
    0002-libxl-use-disk-script-attribute.patch
    0003-libxl-Stubdom-emulator-type.patch
    0004-libxl-support-domain-config-modification-in-virDomai.patch
    0005-Add-nostrictreset-attribute-to-PCI-host-devices.patch
    0006-libxl-pause-also-stubdomain-if-any-while-pausing-a-d.patch
    0007-libxl-plug-workaround-for-missing-pcidev-group-assig.patch
    0008-libxl-add-linux-stubdom-support.patch
    0009-libxl-add-support-for-qubes-graphic-device.patch
    0010-libxl-add-support-for-stubdom_mem-option.patch
    0011-libxl-add-support-for-emulator-kernel-and-ramdisk-pa.patch
    0012-libxl-Fix-setting-invtsc-in-Xen-4.14.patch
    0013-libxl-fail-with-distinct-error-on-unsupported-PM-sus.patch
    0014-libxl-add-support-for-xengt-video-device.patch
    0015-libxl-set-net-disk-trusted-parameter-based-on-backen.patch
    0016-libxl-setup-shadow-memory-according-to-max-hotplug-m.patch
    0017-Add-powerManagementFiltering-for-PCI-PM-control.patch
    0018-libxl-don-t-create-vkb-device-for-qubes-graphics-out.patch
  '';
in

assert libvirt.version == versionPatches;

(libvirt.override {
  enableXen = true;
  xen = qubes-vmm-xen;
}).overrideAttrs (oldAttrs: {
  pname = "qubes-core-libvirt";
  version = "${versionPatches}-${versionSuffix}";

  # I am too lazy to list patches using patches & fetchpatch, we need some ready to use
  # updater script for that.
  postPatch = ''
    # series-qubes.conf in patches repo is outdated!
    echo "${patchSeries}" > series-qubes.conf
    ${patches}/apply-patches series-qubes.conf ${patches}
  '' + optionalString (oldAttrs ? postPatch) oldAttrs.postPatch;

  # FIXME: Override maintainers
})
