{
  lib,
  stdenvNoCC,
  requireFile,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  unzip,
  yq,
  dotnet-runtime_8,
  everest,

  executableName ? "Celeste",
  desktopItems ? null,
  withEverest ? false,
  overrideSrc ? null,
  writableDir ? null,
  launchFlags ? "",
  launchEnv ? "",
  # If we leave it to be the default (log.txt),
  # Everest will try to delete log.txt when it starts,
  # which doesn't work because the file system is read-only.
  # https://github.com/EverestAPI/Everest/blob/050b4a1b4a7918b22d3d5140224f9c0472e1655a/Celeste.Mod.mm/Patches/Celeste.cs#L140-L155
  everestLogFilename ? "everest-log.txt",
}:

# TODO: It appears that it is possible to package Celeste for aarch devices:
# https://github.com/pixelomer/Celeste-ARM64
# However, I don't have an aarch device to do that.
# The ARM support doesn't seem promising because the builder needs to fetch fmod libraries somehow, which requires an account.
# Though this whole process of registration and downloading can possibly be automated, this is probably against the TOS.
let
  pname = "celeste-unwrapped";
  version = "1.4.0.0";
  downloadPage = "https://maddymakesgamesinc.itch.io/celeste";
  description = "2D platformer game about climing a mountain";
  phome = "$out/lib/Celeste";

  launchFlags' =
    if launchFlags != "" && !withEverest then
      lib.warn "launchFlags is useless without Everest." ""
    else
      launchFlags;
  launchEnv' =
    if launchEnv != "" && !withEverest then
      lib.warn "launchEnv is useless without Everest." ""
    else
      ''
        EVEREST_LOG_FILENAME=${everestLogFilename}
        EVEREST_TMPDIR=${writableDir}
        ${launchEnv}
      '';
in
stdenvNoCC.mkDerivation {
  pname = "celeste-unwrapped";
  version = version;

  src =
    if overrideSrc == null then
      requireFile {
        name = "celeste-linux.zip";
        hash = "sha256-phNDBBHb7zwMRaBHT5D0hFEilkx9F31p6IllvLhHQb8=";
        url = downloadPage;
      }
    else
      overrideSrc;
  dontUnpack = true;

  nativeBuildInputs = [
    unzip
    yq
    makeWrapper
    copyDesktopItems
  ];
  desktopItems =
    if desktopItems != null then
      desktopItems
    else
      [
        (makeDesktopItem {
          name = "Celeste";
          desktopName = "Celeste";
          genericName = "Celeste";
          comment = description;
          exec = "${executableName}";
          icon = "Celeste";
          categories = [ "Game" ];
        })
      ];

  postInstall = ''
    mkdir -p ${phome}
    unzip -q $src -d ${phome}
  ''
  + lib.optionalString withEverest ''
    cp -r ${everest}/* $out
    chmod -R +w ${phome} # Files copied from other derivations are not writable by default

    # There will still be a runtime error saying chmod failed for the splash,
    # but it doesn't matter because we make it executable here.
    # https://github.com/EverestAPI/Everest/blob/050b4a1b4a7918b22d3d5140224f9c0472e1655a/Celeste.Mod.mm/Mod/Everest/EverestSplashHandler.cs#L73-L81
    chmod +x ${phome}/EverestSplash/EverestSplash-linux

    # Everest determines whether it is FNA or XNA by the existence of the file.
    # Creating this now prevents it from creating it in the future
    # when the file system is read-only.
    # https://github.com/EverestAPI/Everest/blob/050b4a1b4a7918b22d3d5140224f9c0472e1655a/Celeste.Mod.mm/Patches/Celeste.cs#L41-L47
    touch ${phome}/BuildIsFNA.txt

    # Please Piton by having the runtime.
    # Otherwise it will try to download it.
    # https://github.com/Popax21/Piton/blob/21c7868d06007f0c5e7d9030a0109fe892df1bf3/apphost/src/runtime.rs#L82-L89
    mkdir ${phome}/piton-runtime
    ln -s ${dotnet-runtime_8}/share/dotnet/* -t ${phome}/piton-runtime
    platform=linux-x86_64
    echo -n "$platform $(yq -r .\"$platform\".version ${phome}/piton-runtime.yaml)" > ${phome}/piton-runtime/piton-runtime-id.txt

    chmod +x ${phome}/MiniInstaller-linux
    ${phome}/MiniInstaller-linux

    echo "${launchFlags'}" > ${phome}/everest-launch.txt
    echo "${launchEnv'}" > ${phome}/everest-env.txt
  ''
  + (
    if writableDir != null then
      ''
        mv ${phome}/Celeste ${phome}/Celeste-unwrapped
        ln -s ${writableDir}/Celeste ${phome}/Celeste
      ''
    else
      ''
        ln -s ${phome}/Celeste ${phome}/Celeste-unwrapped
      ''
  )
  + ''
    makeWrapper ${phome}/Celeste-unwrapped $out/bin/${executableName} ${
      # If ${phome}/lib64-linux is not present in LD_LIBRARY_PATH, Everest will try to restart:
      # https://github.com/EverestAPI/Everest/blob/7bd41c26850bbdfef937e2ed929174e864101c4c/Celeste.Mod.mm/Mod/Everest/BOOT.cs#L188-L201
      # It is hardcoded that it launches Celeste instead of Celeste-unwrapped.
      # Therefore, we need to prevent it from restarting.
      lib.optionalString withEverest "--prefix LD_LIBRARY_PATH : ${phome}/lib64-linux"
    } --chdir ${phome}

    icon=$out/share/icons/hicolor/512x512/apps/Celeste.png
    mkdir -p $(dirname $icon)
    ln -s ${phome}/Celeste.png $icon
  '';

  dontPatchELF = true;
  dontStrip = true;
  dontPatchShebangs = true;
  postFixup =
    lib.optionalString withEverest ''
      rm -r ${phome}/Mods # Currently it is empty.
      ln -s "${writableDir}"/{Mods,LogHistory,CrashLogs,${everestLogFilename}} -t ${phome}
    ''
    + lib.optionalString (writableDir != null) ''
      ln -s "${writableDir}/log.txt" -t ${phome}
    '';

  meta = {
    inherit downloadPage description;
    homepage = "https://www.celestegame.com";
    license = with lib.licenses; [ unfree ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
