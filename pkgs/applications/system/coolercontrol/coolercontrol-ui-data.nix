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

  npmDepsHash = "sha256-ZnuTtksB+HVYobL48S3RI8Ibe3pvDaF+YFAJJumiNxA=";

  postBuild = ''
    cp -r dist $out
  '';

  dontInstall = true;

  meta = meta // {
    description = "${meta.description} (UI data)";
  };
}
