# Convert marketplace reference to fetch arguments for VSIX package
#
# This file returns ONLY the attributes needed for fetchurl of the VSIX package.
# Signature-related attributes are intentionally excluded to maintain compatibility
# with existing fetchVsixFromVscodeMarketplace usage.
#
# For signature fetching, use the separate signatureFetchArgs attribute set.
{
  publisher,
  name,
  version,
  arch ? "",
  sha256 ? "",
  hash ? "",
  # Signature hash - accepted but not included in main fetchurl attrs
  signatureSha256 ? "",
  signatureHash ? "",
}:
let
  archurl = (if arch == "" then "" else "?targetPlatform=${arch}");
  baseUrl = "https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname";
in
{
  # VSIX package fetch arguments (for fetchurl)
  url = "${baseUrl}/Microsoft.VisualStudio.Services.VSIXPackage${archurl}";
  inherit sha256 hash;
  # The `*.vsix` file is in the end a simple zip file. Force it using .vsix extension
  # so that existing `unpackVsixSetupHook` hooks takes care of the unpacking.
  name = "${publisher}-${name}.vsix";
}
