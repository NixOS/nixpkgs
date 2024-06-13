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

  npmDepsHash = "sha256-gnJvNQCbqFfPfsqi008HW4kBTpxiVpN7eHyn9bU6if8=";

  postBuild = ''
    cp -r dist $out
  '';

  dontInstall = true;

  meta = meta // {
    description = "${meta.description} (UI data)";
  };
}
