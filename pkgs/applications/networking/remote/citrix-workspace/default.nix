{ lib, callPackage }:

# For detailed information about the Citrix source-tarball, please refer to the OEM
# reference guide: https://developer-docs.citrix.com/en-us/citrix-workspace-app-for-linux/citrix-workspace-app-for-linux-oem-reference-guide

let
  supportedVersions = callPackage ./sources.nix { };

  toAttrName = x: "citrix_workspace_${builtins.replaceStrings [ "." ] [ "_" ] x}";
in
lib.mapAttrs' (
  attr: versionInfo: lib.nameValuePair (toAttrName attr) (callPackage ./generic.nix versionInfo)
) supportedVersions
