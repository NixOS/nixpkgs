{
  publisher,
  name,
  version,
  arch ? "",
  sha256 ? "",
  hash ? "",
}:
let
  archurl = (if arch == "" then "" else "?targetPlatform=${arch}");
in
{
  url = "https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage${archurl}";
  inherit sha256 hash;
  # The `*.vsix` file is in the end a simple zip file. Change the extension
  # so that existing `unzip` hooks takes care of the unpacking.
  name = "${publisher}-${name}.zip";
}
