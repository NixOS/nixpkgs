{ buildNpmPackage
}:

{ version
, src
, meta
}:

buildNpmPackage {
  pname = "coolercontrol-ui";
  inherit version src;
  sourceRoot = "${src.name}/coolercontrol-ui";

  npmDepsHash = "sha256-7Hd1LT1ro83QMuoDGvFGsrTlQaSia+lVG8lyaAibiAo=";

  postBuild = ''
    cp -r dist $out
  '';

  dontInstall = true;

  meta = meta // {
    description = "${meta.description} (UI data)";
  };
}
