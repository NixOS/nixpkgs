{
  buildEnv,
  snis-unwrapped,
  snis-assets,
  makeWrapper,
}:
buildEnv {
  name = "snis-${snis-unwrapped.version}";

  nativeBuildInputs = [ makeWrapper ];

  paths = [
    snis-unwrapped
    snis-assets
  ];

  pathsToLink = [
    "/"
    "/bin"
  ];

  postBuild = ''
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --set SNIS_ASSET_DIR "$out/share/snis"
    done
  '';

  meta = snis-unwrapped.meta // {
    hydraPlatforms = [ ];
  };
}
