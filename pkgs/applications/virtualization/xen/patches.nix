# Patching Xen? Check the XSAs at https://xenbits.xen.org/xsa/
# and try applying all the ones we haven't gotten around to
# yet, if any are necessary. Patches from other downstreams
# are also welcome if they fix important issues with vanilla Xen.

{ lib, fetchpatch }:

let
  xsaPatch =
    {
      id,
      title,
      description,
      type ? "xsa",
      hash ? "",
      cve ? null,
    }:
    (fetchpatch {
      name =
        "XSA-" + id + lib.strings.optionalString (cve != null) ("-" + builtins.concatStringsSep "+" cve);
      url = "https://xenbits.xen.org/xsa/xsa${id}.patch";
      inherit hash;
      passthru = {
        xsa = id;
        inherit type;
      };
      meta = {
        description = title;
        longDescription =
          description
          + "\n"
          + (
            if (cve == null) then
              # Why the two spaces preceding these CVE messages?
              # This is parsed by writeAdvisoryDescription in generic.nix,
              # and doing this was easier than messing with lib.strings even more.
              "  _No CVE was assigned to this XSA._"
            else
              "  Fixes:${
                  lib.strings.concatMapStrings (
                    x: "\n  * [" + x + "](https://www.cve.org/CVERecord?id=" + x + ")"
                  ) cve
                }"
          );
        homepage = "https://xenbits.xenproject.org/xsa/advisory-${id}.html";
      };
    });
  qubesPatch =
    {
      name,
      tag,
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
  # Example patches:
  #
  # "XSA_100" = xsaPatch {
  #   id = "100";
  #   title = "Verbatim Title of XSA";
  #   description = ''
  #     Verbatim description of XSA.
  #   '';
  #   cve = [ "CVE-1999-0001" "CVE-1999-0002" ]; # Not all XSAs have CVEs. This attribute is optional.
  #   hash = "sha256-0000000000000000000000000000000000000000000000000000";
  # };
  #
  # "QUBES_libxl-fix-all-issues" = qubesPatch {
  #   name = "1000-libxl-fix-all-issues";
  #   tag = "4.20.0-1";
  #   hash = "sha256-0000000000000000000000000000000000000000000000000000";
  # };

  # Build reproducibility patches for Xen.
  # Qubes OS has not updated them to later versions of Xen yet,
  # but they appear to work on Xen 4.17.4 - 4.19.0.
  QUBES_REPRODUCIBLE_BUILDS = [
    (qubesPatch {
      name = "1100-Define-build-dates-time-based-on-SOURCE_DATE_EPOCH";
      tag = "4.17.4-5";
      hash = "sha256-OwKA9oPTwhRcSmiOb+PxzifbO/IG8IHWlvddFh/nP6s=";
    })
    (qubesPatch {
      name = "1101-docs-rename-DATE-to-PANDOC_REL_DATE-and-allow-to-spe";
      tag = "4.17.4-5";
      hash = "sha256-BUtYt0mM3bURVaGv4oDznzxx1Wo4sfOpGV5GB8qc5Ns=";
    })
    (qubesPatch {
      name = "1102-docs-xen-headers-use-alphabetical-sorting-for-incont";
      tag = "4.17.4-5";
      hash = "sha256-mQUp2w9lUb7KDq5MuPQjs6y7iuMDeXoZjDjlXfa5z44=";
    })
  ];

  # Xen Security Advisory #458: (4.16.6 - 4.19-rc3)
  "XSA_458" = xsaPatch {
    id = "458";
    title = "Double unlock in x86 guest IRQ handling";
    description = ''
      An optional feature of PCI MSI called "Multiple Message" allows a device
      to use multiple consecutive interrupt vectors.  Unlike for MSI-X, the
      setting up of these consecutive vectors needs to happen all in one go.
      In this handling an error path could be taken in different situations,
      with or without a particular lock held. This error path wrongly releases
      the lock even when it is not currently held.
    '';
    cve = [ "CVE-2024-31143" ];
    hash = "sha256-yHI9Sp/7Ed40iIYQ/HOOIULlfzAzL0c0MGqdF+GR+AQ=";
  };
  # Xen Security Advisory #460: (4.16.6 - 4.19.0)
  "XSA_460" = xsaPatch {
    id = "460";
    title = "Error handling in x86 IOMMU identity mapping";
    description = ''
      Certain PCI devices in a system might be assigned Reserved Memory
      Regions (specified via Reserved Memory Region Reporting, "RMRR") for
      Intel VT-d or Unity Mapping ranges for AMD-Vi.  These are typically used
      for platform tasks such as legacy USB emulation.
      Since the precise purpose of these regions is unknown, once a device
      associated with such a region is active, the mappings of these regions
      need to remain continuouly accessible by the device.  In the logic
      establishing these mappings, error handling was flawed, resulting in
      such mappings to potentially remain in place when they should have been
      removed again.  Respective guests would then gain access to memory
      regions which they aren't supposed to have access to.
    '';
    cve = [ "CVE-2024-31145" ];
    hash = "sha256-3q4nAP2xGEptX6BIpSlALOt2r0kjj1up5pF3xCFp+l0=";
  };
  # Xen Security Advisory #461: (4.16.6 - 4.19.0)
  "XSA_461" = xsaPatch {
    id = "461";
    title = "PCI device pass-through with shared resources";
    description = ''
      When multiple devices share resources and one of them is to be passed
      through to a guest, security of the entire system and of respective
      guests individually cannot really be guaranteed without knowing
      internals of any of the involved guests.  Therefore such a configuration
      cannot really be security-supported, yet making that explicit was so far
      missing.
    '';
    cve = [ "CVE-2024-31146" ];
    hash = "sha256-JQWoqf47hy9WXNkVC/LgmjUhkxN0SBF6w8PF4aFZxhM=";
  };
}
