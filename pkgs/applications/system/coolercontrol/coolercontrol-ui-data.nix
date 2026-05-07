{ buildNpmPackage }:

{
  version,
  src,
  meta,
}:

buildNpmPackage {
  pname = "coolercontrol-ui";
  inherit version src;
  sourceRoot = "${src.name}/coolercontrol-ui";

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-AzRw6DuloOFC7VN7yM9czqxosfVIoXAltv2xHUxac7k=";

  postBuild = ''
    cp -r dist $out
  '';

  dontInstall = true;

  meta = meta // {
    description = "${meta.description} (UI data)";
  };
}
