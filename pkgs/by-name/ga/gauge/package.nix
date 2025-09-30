{
  gauge-unwrapped,
  gauge,
  makeWrapper,
  stdenvNoCC,
  lib,
  xorg,
  gaugePlugins,
  plugins ? [ ],
}:

stdenvNoCC.mkDerivation {
  pname = "gauge-wrapped";
  inherit (gauge-unwrapped) version;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out{bin,/share/gauge/{plugins,config}}
    export NIX_GAUGE_IN_SANDBOX=true
    export GAUGE_HOME=$(mktemp -d)

    # run gauge to create config files
    cd $(mktemp -d)
    gauge init js || true

    mkdir -p "$out/share/gauge/config"
    mv "$GAUGE_HOME"/config/{gauge,template}.properties "$out/share/gauge/config"

    export GAUGE_HOME="$out/share/gauge"

    ${lib.concatMapStringsSep "\n" (plugin: ''
      for plugin in "$(ls ${plugin}/share/gauge-plugins)"; do
        echo Installing gauge plugin $plugin
        mkdir -p "$GAUGE_HOME/plugins/$plugin"
        # Use lndir here
        # gauge checks for a directory, which fails if it's a symlink
        # It's easier to link this with lndir, than patching an upstream dependency
        lndir "${plugin}/share/gauge-plugins/$plugin" "$GAUGE_HOME/plugins/$plugin"
      done
    '') plugins}

    makeWrapper ${gauge-unwrapped}/bin/gauge $out/bin/gauge \
      --set GAUGE_HOME "$GAUGE_HOME"
  '';

  nativeBuildInputs = [
    gauge-unwrapped
    makeWrapper
    xorg.lndir
  ];

  passthru = {
    withPlugins = f: gauge.override { plugins = f gaugePlugins; };
    fromManifest =
      path:
      let
        manifest = lib.importJSON path;
        requiredPlugins = with manifest; [ Language ] ++ Plugins;
        manifestPlugins =
          plugins:
          map (name: plugins.${name} or (throw "Gauge plugin ${name} is not available!")) requiredPlugins;
      in
      gauge.withPlugins manifestPlugins;
    # Builds gauge with all plugins and checks for successful installation
    tests.allPlugins = gaugePlugins.testGaugePlugins {
      plugins = lib.filter lib.isDerivation (lib.attrValues gaugePlugins);
    };
  };

  inherit (gauge-unwrapped) meta;
}
