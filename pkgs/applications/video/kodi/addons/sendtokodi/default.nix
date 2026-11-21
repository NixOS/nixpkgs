{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  kodi,
  inputstreamhelper,
  requests,
  nix-update-script,
  yq-go,
  # yt-dlp used for the "system" yt-dlp source, built for Kodi's Python.
  # Deliberately not named `yt-dlp` to prevent `callPackage` from filling in
  # the top-level default-Python variant.
  ytdlp ? kodi.pythonPackages.yt-dlp,
  # Add-on settings patched into resources/settings.xml. Kodi uses these
  # defaults as long as userdata holds no explicit value. With the packaged
  # yt-dlp (and its baked-in Deno path), nothing needs to be downloaded at
  # runtime.
  settings ? { },
}:

let
  defaultSettings = {
    ytdlp_source = "system";
    deno_autodownload = false;
  };

  effectiveSettings = defaultSettings // settings;

  usesSystemYtdlp = effectiveSettings.ytdlp_source == "system";

  settingValueToString =
    value: if builtins.isBool value then lib.boolToString value else toString value;

  # Assign one default and read it back, so a renamed or restructured setting
  # fails the build instead of being silently ignored. `strenv` keeps the id
  # and the value out of the yq expression itself.
  patchSetting = id: value: ''
    id=${lib.escapeShellArg id}
    value=${lib.escapeShellArg (settingValueToString value)}
    export id value
    yq -p=xml -o=xml -i '(.settings.section.category[].group.setting[] | select(.+@id == strenv(id)) | .default) = strenv(value)' resources/settings.xml
    actual=$(yq -p=xml -o=json -r '.settings.section.category[].group.setting[] | select(.+@id == strenv(id)) | .default' resources/settings.xml)
    [ "$actual" = "$value" ] || {
      echo "resources/settings.xml: default for $id was not applied" >&2
      exit 1
    }
  '';
in
buildKodiAddon rec {
  pname = "sendtokodi";
  namespace = "plugin.video.sendtokodi";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "firsttris";
    repo = "plugin.video.sendtokodi";
    tag = "v${version}";
    hash = "sha256-LCXeAgQ53FeNn5Z7iJJgDk4EsIedCgOFkrGREPIhi1o=";
  };

  nativeBuildInputs = [ yq-go ];

  propagatedBuildInputs = [
    inputstreamhelper
    requests
  ];

  postPatch = ''
    ${lib.optionalString usesSystemYtdlp ''
      # Since 0.10.0 the add-on can use a system-provided yt-dlp ("system"
      # source) through `importlib.import_module("yt_dlp")`. Expose the
      # packaged one via the add-on's `lib` directory, which is added to
      # Kodi's PYTHONPATH (see `passthru.pythonPath`), like script.module.*
      # add-ons do.
      mkdir -p lib
      ln -s ${ytdlp}/${kodi.pythonPackages.python.sitePackages}/yt_dlp lib/

      # yt-dlp's JS-challenge solver scripts (used by its "deno" provider)
      # are shipped in the yt-dlp-ejs python package; expose them as well so
      # no solver script is downloaded at runtime. This is needed whenever
      # the system yt-dlp is used, regardless of how Deno itself is provided.
      ln -s ${kodi.pythonPackages.yt-dlp-ejs}/${kodi.pythonPackages.python.sitePackages}/yt_dlp_ejs lib/
    ''}

    # Patch the default values of the given add-on settings.
    ${lib.concatMapAttrsStringSep "\n" patchSetting effectiveSettings}

    # nixpkgs provides yt-dlp and Deno; lock the add-on's own download
    # settings so they cannot be changed from Kodi's UI.
    yq -p=xml -o=xml -i '
      (.settings.section.category[].group.setting[] |
        select(.+@id == "ytdlp_source" or .+@id == "deno_autodownload") |
        .enable) = "false"
    ' resources/settings.xml
  '';

  passthru = {
    updateScript = nix-update-script { };
  }
  // lib.optionalAttrs usesSystemYtdlp {
    pythonPath = "lib";
  };

  meta = {
    homepage = "https://github.com/firsttris/plugin.video.sendtokodi";
    description = "Plays various stream sites on Kodi using yt-dlp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pks ];
    teams = [ lib.teams.kodi ];
  };
}
