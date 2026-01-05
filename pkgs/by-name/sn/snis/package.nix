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

  # Basic assets are also distributed in the main repo
  ignoreCollisions = true;

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
