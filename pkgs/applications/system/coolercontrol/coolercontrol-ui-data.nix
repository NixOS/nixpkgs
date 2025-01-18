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

  npmDepsHash = "sha256-t+QShKaXpQuEzeeu/ljBBEzeYsxqvMpx5waDZ2gyPAI=";

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
