{ fetchpatch, version }:

let
  qubesPatch =
    {
      name,
      tag ? version,
      type ? "qubes",
      hash ? "",
    }:
    (fetchpatch {
      inherit name;
      url = "https://raw.githubusercontent.com/QubesOS/qubes-vmm-xen/v${tag}/${name}.patch";
      inherit hash;
      passthru.type = type;
    });
in
{
  # We obviously don't need Fedora-specific patches, so this is only included here for completeness.
  FEDORA = [ ];
  EFI_WORKAROUNDS = [
    (qubesPatch {
      name = "0200-EFI-early-Add-noexit-to-inhibit-calling-ExitBootServ";
      hash = "sha256-77PNyzpUaNG/wi5jjWtJy3SOdCc0+MbrcVrEywWBaok=";
    })
    (qubesPatch {
      name = "0201-efi-Ensure-incorrectly-typed-runtime-services-get-ma";
      hash = "sha256-wihn9o0IrCAMRpWL+Fbjmyhs0d27n3pCHmECCA5hp9s=";
    })
    (qubesPatch {
      name = "0202-Add-xen.cfg-options-for-mapbs-and-noexitboot";
      hash = "sha256-ydQgH3aMZO4/Wb8VNaU7/DZF/Hhti15zWGVYTa5PKmk=";
    })
    (qubesPatch {
      name = "0203-xen.efi.build";
      hash = "sha256-/uWEh/QuHHYuqm4pxFJBRQIXb0jTErGQk0Kiwpy4CeY=";
    })
  ];
  BACKPORTS = [
    (qubesPatch {
      name = "0300-xen-list-add-LIST_HEAD_RO_AFTER_INIT";
      hash = "sha256-q2lWcFTT7xq2lFjmBFq/5mYdvkKW81/3H2jEwRA/+aQ=";
    })
    (qubesPatch {
      name = "0301-x86-mm-add-API-for-marking-only-part-of-a-MMIO-page-";
      hash = "sha256-qX82j6ELrQTmrlzjz5/T9BHQnV/MuNTrjwl771DYLas=";
    })
    # Identical to 0319, for some reason.
    (qubesPatch {
      name = "0302-drivers-char-Use-sub-page-ro-API-to-make-just-xhci-d";
      hash = "sha256-DeQx+g/jEYEzUDzLtIX5rVU1DFIu1mTRMbmQEiTF6Qc=";
    })
  ];
  # We already get XSA patches from Xen, so this is only included here for completeness.
  SECURITY_FIXES = [
    (qubesPatch {
      name = "0500-xsa458";
      hash = "sha256-yHI9Sp/7Ed40iIYQ/HOOIULlfzAzL0c0MGqdF+GR+AQ=";
    })
  ];
  UPSTREAMABLE_PATCHES = [
    (qubesPatch {
      name = "0600-libxl-create-writable-error-xenstore-dir";
      hash = "sha256-yhGIDJGN+JYV0zJeNJvfNx5ju8IFQL8Zl+Ol0HZGKCc=";
    })
    (qubesPatch {
      name = "0601-libxl-do-not-wait-for-backend-on-PCI-remove-when-bac";
      hash = "sha256-tbudNDBFK/NS7oa9SsM6xcOBwOjbxciCkEjqG/QVkn0=";
    })
    (qubesPatch {
      name = "0602-libxl-do-not-fail-device-removal-if-backend-domain-i";
      hash = "sha256-s6vmNVWtajYnpClpNMt9c12hQ/r7a+Q/5g/8Fafv7f0=";
    })
    (qubesPatch {
      name = "0603-libvchan-use-xengntshr_unshare-instead-of-munmap-dir";
      hash = "sha256-IDXsXmofLW6+Vamwdxywprt1IrO3C5EDssgxugcYc4Q=";
    })
    (qubesPatch {
      name = "0604-x86-time-Don-t-use-EFI-s-GetTime-call-by-default";
      hash = "sha256-rUVWHu64HHNfjcRCMMEUF9y9UtMMrkxqFDLUc3BenGM=";
    })
    (qubesPatch {
      name = "0605-libxl-automatically-enable-gfx_passthru-if-IGD-is-as";
      hash = "sha256-R5jsBSx8nCrve0FW/Fw70zD4GnHBRymFlHx5CPkyWVs=";
    })
    (qubesPatch {
      name = "0606-autoconf-fix-handling-absolute-PYTHON-path";
      hash = "sha256-8OUOxMB6FI12NtWQBNegF2c6x1pKF0KfGwMV08cSz5s=";
    })
    (qubesPatch {
      name = "0607-libxl-do-not-require-filling-backend_domid-to-remove";
      hash = "sha256-9eg2PIs+NJgmAJa7piIIMfIt7lVZqx+Aa6FSdZc6M9o=";
    })
    (qubesPatch {
      name = "0608-libxl-add-pcidevs-to-stubdomain-earlier";
      hash = "sha256-I/C5Cq1+vG2WEIfm7kxX5DntvjGcLrU2sTmHcoF69do=";
    })
    (qubesPatch {
      name = "0609-Fix-buildid-alignment";
      hash = "sha256-vwqibkhezWa8STghaUZ+d80w/qudjyc665l/kO/tnvs=";
    })
    (qubesPatch {
      name = "0610-vchan-socket-proxy-add-reconnect-marker-support";
      hash = "sha256-Z4EbS4bqAKC7/3D4t710HJdhwfHu6vGiPospUlyT7vM=";
    })
    (qubesPatch {
      name = "0611-tools-libxl-enable-in-band-reconnect-marker-for-stub";
      hash = "sha256-sQKycDr2w6P6dw6KAS/g3pOmb8u6bimOQk2k6Ist/3Y=";
    })
    (qubesPatch {
      name = "0612-libxl-Add-a-utility-function-for-domain-resume";
      hash = "sha256-/Tj1eIUvTNhyHIJ0wUyQwxQO04YWnJzaQ46PFPd5UAc=";
    })
    (qubesPatch {
      name = "0613-libxl-Properly-suspend-stubdomains";
      hash = "sha256-MXvnjABA/WyM26D/gR8T2XV1idQyK3pc/1C1pbj2gW4=";
    })
    (qubesPatch {
      name = "0614-libxl-Fix-race-condition-in-domain-suspension";
      hash = "sha256-paNCg7rpaBiDHFM2LAkDcID3UiUZ0XtjJOCpPsLz0hA=";
    })
    (qubesPatch {
      name = "0615-libxl-Add-additional-domain-suspend-resume-logs";
      hash = "sha256-6iNcHlirlqEHuOxwslG0dDHa2lPZqTuCrLSpRr2s0L0=";
    })
    (qubesPatch {
      name = "0616-libxl-workaround-for-Windows-PV-drivers-removing-con";
      hash = "sha256-8zDDw78bjz4oGbYaUNoSuMO6eWOoj+gfXZ0l2xHNLqQ=";
    })
    (qubesPatch {
      name = "0617-libxl-check-control-feature-before-issuing-pvcontrol";
      hash = "sha256-9nVim2eRxG/HsuulWtkUxbXPWd2LV82QGr4WpM7FlgQ=";
    })
    (qubesPatch {
      name = "0618-tools-kdd-mute-spurious-gcc-warning";
      hash = "sha256-1ODg5Q+sciLT4OYIEfDWaPXblxxxJaiR7naNBKBPwV8=";
    })
    (qubesPatch {
      name = "0619-libxl-do-not-start-qemu-in-dom0-just-for-extra-conso";
      hash = "sha256-A72XOJjNxxYevJq5QyrRWvWQrrJapmZ/syAai146RJ0=";
    })
    (qubesPatch {
      name = "0620-libxl-Allow-stubdomain-to-control-interupts-of-PCI-d";
      hash = "sha256-RpWQlMu9S7Y2h98U4+6Lxumbv7KTje9imEhAls4rN4E=";
    })
    (qubesPatch {
      name = "0621-Validate-EFI-memory-descriptors";
      hash = "sha256-gXJj7f9ZDc5gZ2H3fG8SSamQObldkY/Pmag2/RMNkKk=";
    })
    (qubesPatch {
      name = "0622-x86-mm-make-code-robust-to-future-PAT-changes";
      hash = "sha256-v62CaJOSeIiCOn2oeoRcKi93VLu9zVGOeWIFDI6ViX8=";
    })
    (qubesPatch {
      name = "0623-Drop-ELF-notes-from-non-EFI-binary-too";
      hash = "sha256-PLTr7oZ7BffIGSGtgqJgpAIB1/n87M64UJSoES0h2D8=";
    })
    (qubesPatch {
      name = "0624-xenpm-Factor-out-a-non-fatal-cpuid_parse-variant";
      hash = "sha256-JkAaDDaXAikuaXL3vP1aqfpIBdxvFr132WjB+M2JdNY=";
    })
    (qubesPatch {
      name = "0625-x86-idle-Get-PC-8.10-counters-for-Tiger-and-Alder-La";
      hash = "sha256-pxLu9DYuA+7mtRTLdWc+5T4Pegl1ovdjtjpOIUXQZUY=";
    })
    (qubesPatch {
      name = "0626-x86-ACPI-Ignore-entries-marked-as-unusable-when-pars";
      hash = "sha256-Nz3qVXma0CSyoSqlhXqw+b1/Pn4l/IIJxq9akRJ/PqU=";
    })
    (qubesPatch {
      name = "0627-x86-msr-Allow-hardware-domain-to-read-package-C-stat";
      hash = "sha256-FD5iON3v4LvEL965WizuVY5l8Xcvj2ZdGlkN7YXP+Nk=";
    })
    (qubesPatch {
      name = "0628-x86-mwait-idle-Use-ACPI-for-CPUs-without-hardcoded-C";
      hash = "sha256-39zprrOQbd3kkPGilT0FkoQKWjkXULkNaHKyP4gbHwA=";
    })
    (qubesPatch {
      name = "0629-libxl_pci-Pass-power_mgmt-via-QMP";
      hash = "sha256-RXzoxDADWe+Gr2O6Vch+iCInye+0V4S+n5fQgcReskI=";
    })
    (qubesPatch {
      name = "0653-python-avoid-conflicting-_FORTIFY_SOURCE-values";
      hash = "sha256-OeyNaBtqpqoCsVv85sYgaAEzz8jYcv32BnnvYKHbsqA=";
    })
  ];
  QUBES_SPECIFIC_PATCHES = [
    (qubesPatch {
      name = "1000-Do-not-access-network-during-the-build";
      hash = "sha256-lb/8vKZOcl+kT8lbr6ycneve7i+B6tV3PnvRcPV18bo=";
    })
    (qubesPatch {
      name = "1001-hotplug-store-block-params-for-cleanup";
      hash = "sha256-exumEe3L7q+yVT7GR4D1mprFe7NRpTCOjo/Qx8XVtAQ=";
    })
    (qubesPatch {
      name = "1002-libxl-do-not-start-dom0-qemu-when-not-needed";
      hash = "sha256-nu/trIFKABlK8JwoPJ32Ni9zuJJM924qQ1/Xg9+YEBo=";
    })
    (qubesPatch {
      name = "1003-libxl-do-not-start-qemu-in-dom0-if-possible";
      hash = "sha256-HbYo4SIPK5fp/KeJW9y0etnXrktvYCTlMdMAticiGo0=";
    })
    (qubesPatch {
      name = "1004-systemd-enable-xenconsoled-logging-by-default";
      hash = "sha256-cH1FjAC561gyHkmi1x5Yh2x9gHikWIeFnWe9a6GMR18=";
    })
    (qubesPatch {
      name = "1005-hotplug-trigger-udev-event-on-block-attach-detach";
      hash = "sha256-j8DVPKHwju5gTxo2pt/nhyRK+uEWm90DAW+GYCJbIKg=";
    })
    (qubesPatch {
      name = "1006-libxl-use-EHCI-for-providing-tablet-USB-device";
      hash = "sha256-fECl6ZN0OZPyd+tmbAESks+WYytXQFPE8EWtg6oueGM=";
    })
    (qubesPatch {
      name = "1007-libxl-allow-kernel-cmdline-without-kernel-if-stubdom";
      hash = "sha256-jZpcicFPPhwQ5twHBOISwQGfDUi8gfqRylVU5ErJELk=";
    })
    (qubesPatch {
      name = "1008-libxl-Force-emulating-readonly-disks-as-SCSI";
      hash = "sha256-J1ikG0uS6tBEbM4XaQzE3NQuoSCMU0elOi76hiEnfUU=";
    })
    (qubesPatch {
      name = "1009-tools-xenconsole-replace-ESC-char-on-xenconsole-outp";
      hash = "sha256-NfYqkVX9JVSyivIti0cCJqNYEvVrFR6YeINzmELnjUM=";
    })
    (qubesPatch {
      name = "1010-libxl-disable-vkb-by-default";
      hash = "sha256-Rre4t5RN9/ArJTWvekus5AGHQZBAEvYIPQpL+K++H1o=";
    })
    (qubesPatch {
      name = "1011-Always-allocate-domid-sequentially-and-do-not-reuse-";
      hash = "sha256-qTW6KEXHpXgTQ940wr6lPXuK8rdnRLTb9PPzfctDOuA=";
    })
    (qubesPatch {
      name = "1012-libxl-add-qubes-gui-graphics";
      hash = "sha256-l9X41h1oXffflAkGDHSbqJPHMI9pZWCSoYQgMyoCXWI=";
    })
    (qubesPatch {
      name = "1013-Additional-support-in-ACPI-builder-to-support-SLIC-a";
      hash = "sha256-Dkk0JrWwTA8s6iN8YzSOgxY8D/jXVpmPb1rym/XtsRc=";
    })
    (qubesPatch {
      name = "1014-libxl-conditionally-allow-PCI-passthrough-on-PV-with";
      hash = "sha256-F+02vSeVvSYGOE+e5HmRxzdY/xJNh4AVseh2QV0cV7U=";
    })
    (qubesPatch {
      name = "1015-gnttab-disable-grant-tables-v2-by-default";
      hash = "sha256-jU1NGV8fdzIyDuDQkd7JxJrHds50jmcnRM7zOHL0CjM=";
    })
    (qubesPatch {
      name = "1016-cpufreq-enable-HWP-by-default";
      hash = "sha256-xJ7XKtJHW/hUqZ3WYcafiTK9+z4JWNadG1tmWCoMqnI=";
    })
    (qubesPatch {
      name = "1017-Fix-IGD-passthrough-with-linux-stubdomain";
      hash = "sha256-XWEgC7JQ0buCjaILLbiJjMqC76M4Kcuf9OHVlk4LuvU=";
    })
  ];
  OTHERS = [
    (qubesPatch {
      name = "1100-Define-build-dates-time-based-on-SOURCE_DATE_EPOCH";
      hash = "sha256-IrkLEu9sVX6vu9D3ixBz1M2todAm9+YKc54KvnOL8tI=";
    })
    (qubesPatch {
      name = "1101-docs-rename-DATE-to-PANDOC_REL_DATE-and-allow-to-spe";
      hash = "sha256-k3CflQthQWK3GPgsDPTFqRv9047J0grar16X1X/VIt8=";
    })
    (qubesPatch {
      name = "1102-docs-xen-headers-use-alphabetical-sorting-for-incont";
      hash = "sha256-mQUp2w9lUb7KDq5MuPQjs6y7iuMDeXoZjDjlXfa5z44=";
    })
    (qubesPatch {
      name = "1103-Strip-build-path-directories-in-tools-xen-and-xen-ar";
      hash = "sha256-DzEBjWqhew3u+8H8D8B8luwcr0B0L9enGmgrEm1Fzh4=";
    })
    (qubesPatch {
      name = "1200-hypercall-XENMEM_get_mfn_from_pfn";
      hash = "sha256-2tRs+RyvkkmJasyMgj4VIf19jtpEIpvtaEWpfDkYnhg=";
    })
    (qubesPatch {
      name = "1201-patch-gvt-hvmloader.patch";
      hash = "sha256-uE2YEv94h1/7uOyI43+aTEjeIBqTaRqfSQyuhzvhxP8=";
    })
    (qubesPatch {
      name = "1202-libxl-Add-partially-Intel-GVT-g-support-xengt-device";
      hash = "sha256-MipDZNzYE5YC4vOXbdd4ZKsU/oB/PDT7KFI0xZly40w=";
    })
  ];
  UNUSED = [
    (qubesPatch {
      name = "0317-xen-list-add-LIST_HEAD_RO_AFTER_INIT";
      hash = "sha256-q2lWcFTT7xq2lFjmBFq/5mYdvkKW81/3H2jEwRA/+aQ=";
    })
    (qubesPatch {
      name = "0318-x86-mm-add-API-for-marking-only-part-of-a-MMIO-page-";
      hash = "sha256-UbBgHADeeXXk0DzoITFhm8WqOh0Q9Ghbpaol3tBwKDw=";
    })
    (qubesPatch {
      name = "0319-drivers-char-Use-sub-page-ro-API-to-make-just-xhci-d";
      hash = "sha256-rzKXfmd587y9lTEYd7Gc/q2wmdTVeOLhthUBOGLtlZ0=";
    })
    (qubesPatch {
      name = "1020-xen-tools-qubes-vm";
      hash = "sha256-XgDGLgiloljHqUfHN8pdJIN+1pLFzwCYnOS+Nz0qjbA=";
    })
  ];
}
