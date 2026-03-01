# Convert marketplace reference to fetch arguments for VSIX package
#
# This file returns ONLY the attributes needed for fetchurl of the VSIX package.
# Signature-related attribute (signatureHash) are accepted but excluded from
# the returned fetchurl attrs - use fetchSignatureFromVscodeMarketplace instead.
{
  publisher,
  name,
  version,
  arch ? "",
  sha256 ? "",
  hash ? "",
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
