{ lib, callPackage }:

# For detailed information about the Citrix source-tarball, please refer to the OEM
# reference guide: https://developer-docs.citrix.com/projects/workspace-app-for-linux-oem-guide/en/latest/

let
  inherit (callPackage ./sources.nix { }) supportedVersions unsupportedVersions;

  toAttrName = x: "citrix_workspace_${builtins.replaceStrings [ "." ] [ "_" ] x}";

  unsupported = lib.listToAttrs (
    map (x: lib.nameValuePair (toAttrName x) (throw ''
      Citrix Workspace at version ${x} is not supported anymore!

      Actively supported releases are listed here:
      https://www.citrix.com/support/product-lifecycle/milestones/receiver.html
    '')) unsupportedVersions
  );

  supported = lib.mapAttrs' (
    attr: versionInfo: lib.nameValuePair (toAttrName attr) (callPackage ./generic.nix versionInfo)
  ) supportedVersions;
in
  supported // unsupported
