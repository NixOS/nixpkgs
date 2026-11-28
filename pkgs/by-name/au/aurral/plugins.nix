{
  lib,
  aurral,
  stdenvNoCC,
  fetchFromGitHub,
}:
let
  index = lib.importJSON ./plugins.json;
  src = fetchFromGitHub {
    owner = "lklynet";
    repo = "aurral-plugins";
    inherit (index) tag hash;
  };

  mkPlugin =
    id: plugin:
    stdenvNoCC.mkDerivation {
      pname = "aurral-plugin-${id}";
      inherit (plugin) version;
      inherit src;
      strictDeps = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -r ${id}/. "$out/"
        runHook postInstall
      '';

      passthru.pluginId = id;
      passthru.updateScript = ./update-plugins.sh;

      meta = {
        description = "${plugin.name} plugin for Aurral";
        longDescription = plugin.description;
        homepage = "https://github.com/lklynet/aurral-plugins/tree/${src.tag}/${id}";
        license = [ lib.licenses.mit ] ++ lib.optional (id == "metadata") lib.licenses.lgpl21Plus;
        maintainers = with lib.maintainers; [
          booxter
          staticdev
        ];
        inherit (aurral.meta) platforms;
      };
    };
in
lib.mapAttrs mkPlugin index.plugins
