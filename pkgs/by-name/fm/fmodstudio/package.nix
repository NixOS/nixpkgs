{
  lib,
  stdenvNoCC,
  stdenv,
  runCommand,
  curl,
  jq,
  cacert,
  dpkg,
  _7zz,
  autoPatchelfHook,
  qt6,
  icu56,
  darwin,
  withDoc ? false, # 14M
  withExamples ? false, # 53M
}:

let
  isLinux = stdenv.hostPlatform.isLinux;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fmodstudio";
  version = "2.03.12";

  src =
    runCommand "fmodstudio-download"
      {
        name = "fmodstudio${lib.replaceString "." "" finalAttrs.version}${
          if isLinux then "linux64-installer.deb" else "mac-installer.dmg"
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
            "sha256-jV1GqVqcvRMtK5zgnG4ENbpM3zGm106YfldoG4Ptq8c="
          else
            "sha256-3lUXnHn4qrZa84z6c6RNtD6Yo3oRHLrswBBkyLzSi2c=";
        impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
          "NIX_FMOD_USERNAME"
          "NIX_FMOD_PASSWORD"
          "NIX_FMOD_USER"
          "NIX_FMOD_TOKEN"
        ];
        upstreamPath = "files/fmodstudio/tool/${if isLinux then "Linux" else "Mac"}/";
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
      [
        dpkg
        autoPatchelfHook
        qt6.wrapQtAppsHook
      ]
    else
      [ _7zz ] ++ lib.optional (!withDoc || !withExamples) darwin.autoSignDarwinBinariesHook;

  buildInputs = lib.optionals isLinux [
    stdenv.cc.cc
    icu56
    qt6.qtbase
    qt6.qtwebengine
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString isLinux ''
    mkdir -p $out/{bin,opt/fmodstudio/lib}
    ${lib.optionalString withDoc "cp -ar opt/fmodstudio/documentation $out/opt/fmodstudio"}
    ${lib.optionalString withExamples "cp -ar opt/fmodstudio/examples $out/opt/fmodstudio"}
    cp -ar opt/fmodstudio/{Plugins,Scripts,fmodstudio{,cl}} $out/opt/fmodstudio
    cp -a opt/fmodstudio/lib/lib{fsbvorbis,opus,studio}.* $out/opt/fmodstudio/lib
    cp -ar usr/* $out
    ln -s $out/opt/fmodstudio/fmodstudio{,cl} -t $out/bin
  ''
  + lib.optionalString (!isLinux) ''
    mkdir -p $out/{Applications,bin}
    cp -ar "FMOD Studio.app" $out/Applications
    ${lib.optionalString (
      !withDoc
    ) "rm -r \"$out/Applications/FMOD Studio.app/Contents/Resources/documentation\""}
    ${lib.optionalString (
      !withExamples
    ) "rm -r \"$out/Applications/FMOD Studio.app/Contents/Resources/examples\""}
    tee > $out/bin/fmodstudio <<EOF
    #!/bin/sh
    exec open -n "$out/Applications/FMOD Studio.app" --args "\$@"
    EOF
    chmod +x $out/bin/fmodstudio
  ''
  + ''
    runHook postInstall
  '';

  preFixup = lib.optionalString isLinux ''
    substituteInPlace $out/share/applications/fmodstudio.desktop \
      --replace-fail Exec=/opt/fmodstudio/fmodstudio Exec=fmodstudio
  '';

  meta = {
    description = "Desktop application for creation of adaptive audio";
    homepage = "https://www.fmod.com";
    downloadPage = "https://www.fmod.com/download#fmodstudio";
    changelog = "https://www.fmod.com/docs/${finalAttrs.version}/studio/welcome-to-fmod-studio-revision-history.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "fmodstudio";
  };
})
