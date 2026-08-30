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
  npmDepsHash = "sha256-zolbx5ROiFzNhPGcOnJjEiY3W2IXI24wLKPj3wRSLXU=";

  postBuild = ''
    cp -r dist $out
  '';

  dontInstall = true;

  meta = meta // {
    description = "${meta.description} (UI data)";
  };
}
