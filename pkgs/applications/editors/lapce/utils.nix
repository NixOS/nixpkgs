{
  stdenvNoCC,
  curl,
  cacert,
  zstd,
  linkFarm,
}:
let
  fetchPluginTarballFromRegistry =
    {
      author,
      name,
      version,
      hash,
      meta,
    }:
    stdenvNoCC.mkDerivation (
      let
        url = "https://plugins.lapce.dev/api/v1/plugins/${author}/${name}/${version}/download";
        file = "lapce-plugin-${author}-${name}-${version}.tar.zstd";
      in
      {
        name = file;
        nativeBuildInputs = [
          curl
          cacert
        ];
        dontUnpack = true;
        dontBuild = true;
        installPhase = ''
          runHook preInstall

          url="$(curl ${url})"
          curl -L "$url" -o "$out"

          runHook postInstall
        '';
        outputHashAlgo = "sha256";
        outputHashMode = "flat";
        outputHash = hash;
        inherit meta;
      }
    );
  pluginFromRegistry =
    {
      author,
      name,
      version,
      hash,
      meta,
    }@args:
    stdenvNoCC.mkDerivation {
      pname = "lapce-plugin-${author}-${name}";
      inherit version;
      src = fetchPluginTarballFromRegistry args;
      nativeBuildInputs = [ zstd ];
      dontUnpack = true;
      dontBuild = true;
      installPhase = ''
        runHook preInstall

        mkdir -p $out
        tar -C $out -xvf $src

        runHook postInstall
      '';
      inherit meta;
    };
  pluginsFromRegistry =
    plugins:
    linkFarm "lapce-plugins" (
      builtins.listToAttrs (
        builtins.map (
          {
            author,
            name,
            version,
            ...
          }@plugin:
          {
            name = "${author}-${name}-${version}";
            value = pluginFromRegistry plugin;
          }
        ) plugins
      )
    );
in
{
  inherit pluginsFromRegistry pluginFromRegistry fetchPluginTarballFromRegistry;
}
