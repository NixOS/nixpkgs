{
  fetchurl,
  ungoogled-chromium,
  lib,
  makeDesktopItem,
  runtimeShell,
  symlinkJoin,
  writeScriptBin,
  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? [],
}: let
  pname = "shikimori";
  version = "0.1.0";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = fetchurl {
      name = "shikimori-logo.svg";
      url = "https://raw.githubusercontent.com/shikimori/shikimori/a6205d375bd10b581a98e2c37f0d5a380d624c50/app/assets/images/src/favicon.svg";
      sha256 = "sha256-JGuiJuqMSNopputLK8UBu7AeA3dZDG8A8SGJbX80Wp0=";
      meta.license = lib.licenses.osl3;
    };
    desktopName = "Shikimori";
    genericName = "Encyclopedia of anime, manga and light novels";
    categories = ["TV" "AudioVideo" "Network"];
    startupNotify = true;
  };

  script = writeScriptBin pname ''
    #!${runtimeShell}
    exec ${ungoogled-chromium}/bin/${ungoogled-chromium.meta.mainProgram} ${lib.escapeShellArgs commandLineArgs} \
      --app=https://shikimori.one \
      --no-first-run \
      --no-default-browser-check \
      --no-crash-upload \
      "$@"
  '';

  meta = with lib; {
    description = "Shikimori is a Russian-language encyclopedia of anime, manga and light novels";
    homepage = "https://shikimori.one";
    license = licenses.osl3;
    platforms = ungoogled-chromium.meta.platforms or lib.platforms.all;
    maintainers = with maintainers; [yunfachi];
    mainProgram = "shikimori";
  };
in
  symlinkJoin {
    inherit meta;
    name = pname;
    paths = [script desktopItem];
  }
