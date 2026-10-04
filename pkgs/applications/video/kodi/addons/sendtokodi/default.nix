{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  kodi,
  inputstreamhelper,
  requests,
  nix-update-script,
  # yt-dlp used for the "system" yt-dlp source, built for Kodi's Python.
  # Deliberately not named `yt-dlp` to prevent `callPackage` from filling in
  # the top-level default-Python variant.
  ytdlp ? kodi.pythonPackages.yt-dlp,
  # Default add-on settings patched into resources/settings.xml. Kodi uses
  # these defaults as long as userdata holds no explicit value. With the
  # packaged yt-dlp (and its baked-in Deno path), nothing needs to be
  # downloaded at runtime.
  settings ? {
    ytdlp_source = "system";
    deno_autodownload = false;
  },
}:

let
  # Nix does not coerce booleans to strings, unlike integers.
  settingValueToString =
    value: if builtins.isBool value then lib.boolToString value else toString value;
in
buildKodiAddon rec {
  pname = "sendtokodi";
  namespace = "plugin.video.sendtokodi";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "firsttris";
    repo = "plugin.video.sendtokodi";
    tag = "v${version}";
    hash = "sha256-+xEso7Na+ffo/tdZc33/3UKGk+ZuN5yaPH2Se8CSr8w=";
  };

  propagatedBuildInputs = [
    inputstreamhelper
    requests
  ];

  postPatch = ''
    # Since 0.10.0 the add-on can use a system-provided yt-dlp ("system"
    # source) through `importlib.import_module("yt_dlp")`. Expose the
    # packaged one via the add-on's `lib` directory, which is added to
    # Kodi's PYTHONPATH (see `passthru.pythonPath`), like script.module.*
    # add-ons do.
    mkdir -p lib
    ln -s ${ytdlp}/${kodi.pythonPackages.python.sitePackages}/yt_dlp lib/

    # yt-dlp's JS-challenge solver scripts (used by its "deno" provider) are
    # shipped in the yt-dlp-ejs python package; expose them as well so that
    # no solver script is downloaded at runtime.
    ln -s ${kodi.pythonPackages.yt-dlp-ejs}/${kodi.pythonPackages.python.sitePackages}/yt_dlp_ejs lib/

    # Patch the default values of the given add-on settings.
    ${lib.concatMapAttrsStringSep "\n" (
      id: value:
      "sed -i '/<setting[^>]*id=\"${id}\"/,/<\\/setting>/ s#<default>[^<]*</default>#<default>${settingValueToString value}</default>#' resources/settings.xml"
    ) settings}
  '';

  passthru = {
    pythonPath = "lib";
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/firsttris/plugin.video.sendtokodi";
    description = "Plays various stream sites on Kodi using yt-dlp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pks ];
    teams = [ lib.teams.kodi ];
  };
}
