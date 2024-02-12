{ lib
, buildNpmPackage
, fetchFromGitHub
, electron_27
}:

let
  electron = electron_27;
in buildNpmPackage rec {
  pname = "feishin";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = "feishin";
    rev = "refs/tags/v${version}";
    hash = "sha256-yzaWOucz1lPWFlknPc8g74LfX/pFFQ2JRYSgauNGMRQ=";
  };

  npmDepsHash = "sha256-Fa59nwkkMHp9GNY8piAz3usNU4lhTzwonlmowFf5qqY=";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "electron-builder install-app-deps &&" ""
  '';

  npmFlags = [ "--legacy-peer-deps" ];

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postBuild = ''
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false
  '';

  installPhase = ''
    runHook preInstall

    pushd release/build/*/
    mkdir -p $out/opt/feishin
    cp -r locales resources{,.pak} $out/opt/feishin
    popd

    makeWrapper ${lib.getExe electron} $out/bin/feishin \
      --add-flags $out/opt/feishin/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

    runHook postInstall
  '';

  meta = with lib; {
    description = "Full-featured Subsonic/Jellyfin compatible desktop music player";
    homepage = "https://github.com/jeffvli/feishin";
    changelog = "https://github.com/jeffvli/feishin/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "feishin";
    maintainers = with maintainers; [ onny ];
  };
}
