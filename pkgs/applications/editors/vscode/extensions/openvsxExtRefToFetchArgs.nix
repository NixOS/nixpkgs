{ publisher, name, version, arch ? "", sha256 ? "" }:
let
  url =
    if arch == ""
    then "https://open-vsx.org/api/${publisher}/${name}/${version}/file/${publisher}.${name}-${version}.vsix"
    else "https://open-vsx.org/api/${publisher}/${name}/${arch}/${version}/file/${publisher}.${name}-${version}.vsix";
in
{
  inherit url;
  sha256 = sha256;
  name = "${publisher}-${name}.zip";
}
