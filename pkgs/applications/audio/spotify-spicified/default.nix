{ lib
, spotify-unwrapped
, spicetify-cli
, spicetify-themes

  # Spicetify settings
, theme ? ""
, colorScheme ? ""
, thirdParyThemes ? {}
, thirdParyExtensions ? {}
, thirdParyCustomApps ? {}
, enabledExtensions ? []
, enabledCustomApps ? []
, spotifyLaunchFlags ? ""
, injectCss ? false
, replaceColors ? false
, overwriteAssets ? false
, disableSentry ? true
, disableUiLogging ? true
, removeRtlRule ? true
, exposeApis ? true
, disableUpgradeCheck ? true
, fastUserSwitching ? false
, visualizationHighFramerate ? false
, radio ? false
, songPage ? false
, experimentalFeatures ? false
, home ? false
, lyricAlwaysShow ? false
, lyricForceNoSync ? false
}:

with lib;

let
  # Helper functions
  pipeConcat = lists.foldr (a: b: a + "|" + b) "";
  lineBreakConcat = foldr (a: b: a + "\n" + b) "";
  boolToString = x: if x then "1" else "0";
  makeLnCommands = type:
    (attrsets.mapAttrsToList (name: path: "ln -sf ${path} ./${type}/${name}"));

  # Setup spicetify
  spicetify = "SPICETIFY_CONFIG=. ${spicetify-cli}/bin/spicetify-cli";

  # Dribblish is a theme which needs a couple extra settings
  isDribblish = theme == "Dribbblish";

  extraCommands = (optionalString isDribblish ''
    cp ./Themes/Dribbblish/dribbblish.js ./Extensions
  '') + (lineBreakConcat (makeLnCommands "Themes" thirdParyThemes))
    + (lineBreakConcat (makeLnCommands "Extensions" thirdParyExtensions))
    + (lineBreakConcat (makeLnCommands "CustomApps" thirdParyCustomApps));

  customAppsFixupCommands =
    lineBreakConcat (makeLnCommands "Apps" thirdParyCustomApps);

  injectCssOrDribblish = boolToString (isDribblish || injectCss);
  replaceColorsOrDribblish = boolToString (isDribblish || replaceColors);
  overwriteAssetsOrDribblish = boolToString (isDribblish || overwriteAssets);

  extensionString = pipeConcat
    ((optionals isDribblish [ "dribbblish.js" ]) ++ enabledExtensions);
  customAppsString = pipeConcat enabledCustomApps;
in spotify-unwrapped.overrideAttrs (oldAttrs: rec {
  name = "spotify-spicified-${spotify-unwrapped.version}";

  postInstall = ''
    touch $out/prefs
    mkdir Themes Extensions CustomApps

    find ${spicetify-themes} -maxdepth 1 -type d -exec ln -s {} Themes \;
    ${extraCommands}

    ${spicetify} config \
      spotify_path "$out/share/spotify" \
      prefs_path "$out/prefs" \
      ${optionalString (theme != "") ''current_theme "${theme}"''} \
      ${optionalString (colorScheme != "") ''color_scheme "${colorScheme}"''} \
      ${
        optionalString (extensionString != "")
        ''extensions "${extensionString}"''
      } \
      ${
        optionalString (customAppsString != "")
        ''custom_apps "${customAppsString}"''
      } \
      ${
        optionalString (spotifyLaunchFlags != "")
        ''spotify_launch_flags "${spotifyLaunchFlags}"''
      } \
      inject_css ${injectCssOrDribblish} \
      replace_colors ${replaceColorsOrDribblish} \
      overwrite_assets ${overwriteAssetsOrDribblish} \
      disable_sentry ${boolToString disableSentry} \
      disable_ui_logging ${boolToString disableUiLogging} \
      remove_rtl_rule ${boolToString removeRtlRule} \
      expose_apis ${boolToString exposeApis} \
      disable_upgrade_check ${boolToString disableUpgradeCheck} \
      fastUser_switching ${boolToString fastUserSwitching} \
      visualization_high_framerate ${boolToString visualizationHighFramerate} \
      radio ${boolToString radio} \
      song_page ${boolToString songPage} \
      experimental_features ${boolToString experimentalFeatures} \
      home ${boolToString home} \
      lyric_always_show ${boolToString lyricAlwaysShow} \
      lyric_force_no_sync ${boolToString lyricForceNoSync}

    ${spicetify} backup apply

    cd $out/share/spotify
    ${customAppsFixupCommands}
  '';

  meta = spotify-unwrapped.meta // {
    priority = (spotify-unwrapped.meta.priority or 0) - 1;
  };
})
