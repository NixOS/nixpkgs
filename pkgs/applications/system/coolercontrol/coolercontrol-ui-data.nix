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
  npmDepsHash = "sha256-NmTNaHm7NGkNWnNbTfLC9/3cSJRR+ir1YS+ot4MJNog=";

  postBuild = ''
    cp -r dist $out
  '';

  dontInstall = true;

  meta = meta // {
    description = "${meta.description} (UI data)";
  };
}
