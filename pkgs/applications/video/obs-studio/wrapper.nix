{
  lib,
  stdenv,
  stdenvNoCC,
  obs-studio,
  symlinkJoin,
  makeWrapper,
  makeBinaryWrapper,
}:

{
  plugins ? [ ],
}:

if stdenv.hostPlatform.isDarwin then
  # OBS.app with the plugins' bundles (lib/obs-plugins/*.plugin) among its
  # own. OBS looks for its plugins in the bundle it runs from, so its
  # executables are copies; the rest of the bundle links to obs-studio's.
  stdenvNoCC.mkDerivation {
    name = "wrapped-${obs-studio.name}";

    nativeBuildInputs = [ makeBinaryWrapper ];

    dontUnpack = true;
    # The executables are copied as they are, signed.
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      original=${obs-studio}/Applications/OBS.app
      app=$out/Applications/OBS.app
      mkdir -p $app/Contents/MacOS $app/Contents/PlugIns $out/bin
      for entry in $original/Contents/*; do
        case ''${entry##*/} in
          MacOS | PlugIns) ;;
          *) ln -s $entry $app/Contents/ ;;
        esac
      done
      cp $original/Contents/MacOS/* $app/Contents/MacOS/
      ln -s $original/Contents/PlugIns/* $app/Contents/PlugIns/
      ${lib.concatMapStrings (plugin: ''
        ln -s ${plugin}/lib/obs-plugins/*.plugin $app/Contents/PlugIns/
      '') plugins}
      makeBinaryWrapper $app/Contents/MacOS/OBS $out/bin/obs

      runHook postInstall
    '';

    inherit (obs-studio) meta;
    passthru = obs-studio.passthru // {
      unwrapped = obs-studio;
    };
  }
else
  symlinkJoin {
    name = "wrapped-${obs-studio.name}";

    nativeBuildInputs = [ makeWrapper ];
    paths = [ obs-studio ] ++ plugins;

    postBuild =
      let
        # Some plugins needs extra environment, see obs-gstreamer for an example.
        pluginArguments = lib.lists.concatMap (plugin: plugin.obsWrapperArguments or [ ]) plugins;

        pluginsJoined = symlinkJoin {
          name = "obs-studio-plugins";
          paths = plugins;
        };

        wrapCommandLine = [
          "wrapProgram"
          "$out/bin/obs"
          ''--set OBS_PLUGINS_PATH "${pluginsJoined}/lib/obs-plugins"''
          ''--set OBS_PLUGINS_DATA_PATH "${pluginsJoined}/share/obs/obs-plugins"''
        ]
        ++ lib.lists.unique pluginArguments;
      in
      ''
        ${lib.concatStringsSep " " wrapCommandLine}

        # Remove unused obs-plugins dir to not cause confusion
        rm -r $out/share/obs/obs-plugins
        # Leave some breadcrumbs
        echo 'Plugins are at ${pluginsJoined}/share/obs/obs-plugins' > $out/share/obs/obs-plugins-README
      '';

    inherit (obs-studio) meta;
    passthru = obs-studio.passthru // {
      passthru.unwrapped = obs-studio;
    };
  }
