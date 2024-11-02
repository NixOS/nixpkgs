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

  npmDepsHash = "sha256-PpX9lk+yEG1auvBv5JBdMh7rjWoM0oTYJx6Nme5ij8s=";

  postBuild = ''
    cp -r dist $out
  '';

  dontInstall = true;

  meta = meta // {
    description = "${meta.description} (UI data)";
  };
}
