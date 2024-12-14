{ buildNpmPackage, autoPatchelfHook }:

{
  version,
  src,
  meta,
}:

buildNpmPackage {
  pname = "coolercontrol-ui";
  inherit version src;
  sourceRoot = "${src.name}/coolercontrol-ui";

  npmDepsHash = "sha256-j+bGOGIG9H/1z0dN8BfvWSi6gPvYmCV7l0ZNH8h3yeU=";

  preBuild = ''
    autoPatchelf node_modules/sass-embedded-linux-x64/dart-sass/src/dart
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  dontAutoPatchelf = true;

  postBuild = ''
    cp -r dist $out
  '';

  dontInstall = true;

  meta = meta // {
    description = "${meta.description} (UI data)";
  };
}
