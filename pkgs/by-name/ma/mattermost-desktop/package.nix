{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  electron,
  makeWrapper,
  testers,
  mattermost-desktop,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "mattermost-desktop";
  version = "5.10.2";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "desktop";
    tag = "v${version}";
    hash = "sha256-LHjVmrsOdk8vfsqvNEWkzpusm6jbz3SOb3bEaIb7rb4=";
  };

  npmDepsHash = "sha256-LAbqsMdMmmHGgvg2ilz6neQxMOK3jtCKt8K0M8BWifs=";
  npmBuildScript = "build-prod";
  makeCacheWritable = true;

  nativeBuildInputs = [ makeWrapper ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postPatch = ''
    substituteInPlace webpack.config.base.js \
      --replace-fail \
        "const VERSION = childProcess.execSync('git rev-parse --short HEAD', {cwd: __dirname}).toString();" \
        "const VERSION = process.env.version;"
  '';

  postBuild = ''
    # electronDist needs to be writable
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
        --config electron-builder.json \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents \
      $out/bin \
      $out/share/applications \
      $out/share/icons/hicolor/512x512/apps

    readonly dist=release/linux-unpacked

    cp -a $dist/resources $out/share/${pname}

    patchShebangs $dist/create_desktop_file.sh
    $dist/create_desktop_file.sh
    mv Mattermost.desktop $out/share/applications/
    substituteInPlace $out/share/applications/Mattermost.desktop \
      --replace-fail /build/source/$dist/app_icon.png ${pname} \
      --replace-fail /build/source/$dist/ $out/bin/

    cp src/assets/linux/app_icon.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    makeWrapper '${lib.getExe electron}' $out/bin/${pname} \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags $out/share/${pname}/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = mattermost-desktop;
      # Invoking with `--version` insists on being able to write to a log file.
      command = "env HOME=/tmp ${meta.mainProgram} --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Mattermost Desktop client";
    mainProgram = "mattermost-desktop";
    homepage = "https://about.mattermost.com/";
    changelog = "https://github.com/mattermost/desktop/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    platforms = electron.meta.platforms;
    maintainers = with lib.maintainers; [
      joko
      liff
    ];
  };
}
