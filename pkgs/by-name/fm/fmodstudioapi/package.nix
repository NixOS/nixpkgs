{
  lib,
  stdenv,
  stdenvNoCC,
  runCommand,
  versionCheckHook,
  copyDesktopItems,
  makeDesktopItem,
  cacert,
  jq,
  _7zz,
  autoPatchelfHook,
  curl,
  qt6,
  icu56,
  withFsbank ? withFsbankTool,
  withStudio ? true,
  withFsbankTool ? false,
  withFmodProfiler ? false,
  withResonanceAudio ? false,
  withFmodHaptics ? false,
  withDoc ? false,
}:

let
  isLinux = stdenv.hostPlatform.isLinux;
in

assert
  !isLinux
  || stdenv.hostPlatform.isx86_64
  || !withFsbankTool && !withFmodProfiler && !withResonanceAudio;
assert !isLinux || withFsbank || !withFsbankTool;
assert !isLinux || stdenv.hostPlatform.isx86 || !withFsbank;
assert isLinux || !withFmodHaptics;

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fmodstudioapi";
  version = "2.03.12";

  src =
    runCommand "fmodstudioapi-download"
      {
        name = "fmodstudioapi${lib.replaceString "." "" finalAttrs.version}${
          if isLinux then "linux.tar.gz" else "mac-installer.dmg"
        }";
        nativeBuildInputs = [
          curl
          jq
          cacert
        ];
        outputHashAlgo = "sha256";
        outputHashMode = "flat";
        outputHash =
          if isLinux then
            "sha256-Wz5LJnXRZN7GaFwTT9tbyZiRkgyJr93C1LdFyFH5THI="
          else
            "sha256-uHDXO8WCLpYpvOX9Y495QidbTvquW4+EjyMb5YMumYs=";
        impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
          "NIX_FMOD_USERNAME"
          "NIX_FMOD_PASSWORD"
          "NIX_FMOD_USER"
          "NIX_FMOD_TOKEN"
        ];
        upstreamPath = "files/fmodstudio/api/${if isLinux then "Linux" else "Mac"}/";
      }
      ''
        if [[ -z "$NIX_FMOD_TOKEN" ]] || [[ -z "$NIX_FMOD_USER" ]]; then
          if [[ -z "$NIX_FMOD_USERNAME" ]] || [[ -z "$NIX_FMOD_PASSWORD" ]]; then
            echo >&2
            echo "***" >&2
            echo "Cannot download FMOD Studio API due to lack of credentials. You may try either of the following options:" >&2
            echo "1. Download ${finalAttrs.src.name} manually from ${finalAttrs.meta.downloadPage}" >&2
            echo "   and add it to the Nix store by running `nix-store --add-fixed sha256 ${finalAttrs.src.name}`." >&2
            echo "2. Put credentials in environment variables for the Nix builder process (nix-daemon in the multi-user case):" >&2
            echo "   either set NIX_FMOD_TOKEN and NIX_FMOD_USER or set NIX_FMOD_USERNAME and NIX_FMOD_PASSWORD." >&2
            echo "***" >&2
            echo >&2
            exit 1
          fi

          auth="$(curl -s -X POST -u "$NIX_FMOD_USERNAME:$NIX_FMOD_PASSWORD" "https://www.fmod.com/api-login" -d "{}")"
          NIX_FMOD_TOKEN="$(echo "$auth" | jq -r .token)"
          NIX_FMOD_USER="$(echo "$auth" | jq -r .user)"
        fi

        url="https://www.fmod.com/api-get-download-link?path=$upstreamPath&filename=${finalAttrs.src.name}&user_id=$NIX_FMOD_USER"
        url="$(curl -s -H "Authorization: FMOD $NIX_FMOD_TOKEN" "$url" | jq -r .url)"
        curl -L -o $out "$url"
      '';

  nativeBuildInputs =
    if isLinux then
      [ autoPatchelfHook ] ++ lib.optionals (withFsbankTool || withFmodProfiler) [ qt6.wrapQtAppsHook ]
    else
      [ _7zz ];

  buildInputs = lib.optionals isLinux (
    [ stdenv.cc.cc ]
    ++ lib.optionals (withFsbankTool || withFmodProfiler) [
      icu56
      qt6.qtbase
    ]
  );

  installPhase =
    let
      libPath =
        if isLinux then
          {
            i386 = "x86/";
            x86_64 = "x86_64/";
            arm = "arm/";
            arm64 = "arm64/";
          }
          .${stdenvNoCC.hostPlatform.linuxArch}
        else
          "";
    in
    ''
      runHook preInstall

      install -Dm644 doc/LICENSE.TXT -t $out/share/licenses/fmodstudioapi
      mkdir -p $out/{include,lib}
      cp -a api/core/lib/${libPath}* $out/lib
      cp -a api/core/inc/* $out/include
    ''
    + lib.optionalString withStudio ''
      cp -a api/studio/lib/${libPath}* $out/lib
      cp -a api/studio/inc/* $out/include
    ''
    + lib.optionalString withFsbank ''
      cp -a api/fsbank/lib/${libPath}* $out/lib
      cp -a api/fsbank/inc/* $out/include
    ''
    + lib.optionalString withDoc ''
      mkdir -p $out/share/doc
      cp -r "doc/FMOD API User Manual" $out/share/doc
    ''
    + lib.optionalString (isLinux && withFsbankTool) ''
      install -Dm755 bin/fsbank{,_gui} -t $out/bin
    ''
    + lib.optionalString (!isLinux && withFsbankTool) ''
      mkdir -p $out/{Applications,bin}
      cp -r "tools/FSBank.app" $out/Applications
      tee > $out/bin/fsbank_gui <<EOF
      #!/bin/sh
      exec open -n "$out/Applications/FSBank.app" --args "\$@"
      EOF
      chmod +x $out/bin/fsbank_gui
    ''
    + lib.optionalString (isLinux && withFmodProfiler) ''
      install -Dm755 bin/fmodprofiler -t $out/bin
    ''
    + lib.optionalString (!isLinux && withFmodProfiler) ''
      mkdir -p $out/{Applications,bin}
      cp -r "tools/FMOD Profiler.app" $out/Applications
      tee > $out/bin/fmodprofiler <<EOF
      #!/bin/sh
      exec open -n "$out/Applications/FMOD Profiler.app" --args "\$@"
      EOF
      chmod +x $out/bin/fmodprofiler
    ''
    + lib.optionalString withResonanceAudio ''
      cp -a plugins/resonance_audio/lib/* $out/lib
      cp -a plugins/resonance_audio/inc/* $out/include
      install -Dm644 plugins/resonance_audio/license.txt -t $out/share/licenses/fmodstudioapi/resonance_audio
    ''
    + lib.optionalString withFmodHaptics ''
      cp -a plugins/fmod_haptics/lib/* $out/lib
    ''
    + ''
      runHook postInstall
    '';

  desktopItems =
    lib.optional withFsbankTool (makeDesktopItem {
      name = "fsbank";
      exec = "fsbank_gui";
      desktopName = "FSBank";
      comment = "FMOD SoundBank Generator";
      categories = [
        "AudioVideo"
        "Audio"
      ];
    })
    ++ lib.optional withFmodProfiler (makeDesktopItem {
      name = "fmodprofiler";
      exec = "fmodprofiler";
      desktopName = "FMOD Profiler";
      categories = [
        "AudioVideo"
        "Audio"
      ];
    });

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = withFsbankTool && isLinux;
  versionCheckProgram = "${placeholder "out"}/bin/fsbank";
  versionCheckProgramArg = "-help";

  meta = {
    description = "Library for integration of the FMOD run-time with custom engines";
    homepage = "https://www.fmod.com";
    downloadPage = "https://www.fmod.com/download#fmodengine";
    changelog = "https://www.fmod.com/docs/${finalAttrs.version}/api/welcome-revision-history.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
