{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  electron,
  python3,
  xcodebuild,
  applyPatches,
}:
buildNpmPackage (finalAttrs: {
  pname = "dopamine";
  version = "3.0.7";

  # needed to upgrade better-sqlite3 in npmConfigHook
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "digimezzo";
      repo = "dopamine";
      tag = "v${finalAttrs.version}";
      hash = "sha256-zYuf5BIQaxTqHBXWX1PLghGR5WmwtnSxTYrNosVFebc=";
    };
    patches = [
      # register-scheme contains install scripts, but has no lockfile
      ./remove-register-scheme.patch

      # fixes node-addon-api errors with aarch64-darwin
      ./update-node-addon-api.patch

      # bump better-sqlite3 to work with electron 41
      ./bump-better-sqlite3.patch
    ];
  };

  npmDepsHash = "sha256-m5y8TmOUAUf2IE87b73hFe2vj/uRAqFGgfuy3vkUX/s=";

  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ distutils ]))
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodebuild ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    # needed for better-sqlite3 rebuild
    export npm_config_nodedir="${electron.headers}"
    export npm_config_target="${electron.version}"

    npm rebuild --verbose --no-progress --offline

    # reduce better-sqlite3 size
    pushd node_modules/better-sqlite3
    rm -rf src deps build/{deps,Release/{.deps,obj,obj.target,test_extension.node}}
    popd

    npm run build:prod

    # otherwise angular uses up ~150MB space
    rm -rf .angular

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          cp -r ${electron.dist}/Electron.app ./
          find ./Electron.app -name 'Info.plist' -exec chmod +rw {} \;

          npm exec electron-builder -- \
            --dir \
            -c.npmRebuild=false \
            -c.mac.identity=null \
            -c.electronDist=./ \
            -c.electronVersion=${electron.version} \
            -c.extraMetadata.version=v${finalAttrs.version} \
            --config electron-builder.config.js
        ''
      else
        ''
          npm exec electron-builder -- \
            --dir \
            -c.npmRebuild=false \
            -c.electronDist=${electron.dist} \
            -c.electronVersion=${electron.version} \
            -c.extraMetadata.version=v${finalAttrs.version} \
            --config electron-builder.config.js
        ''
    }

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/{Applications,bin}
          cp -r release/mac*/Dopamine.app $out/Applications
          makeWrapper $out/Applications/Dopamine.app/Contents/MacOS/Dopamine $out/bin/dopamine
        ''
      else
        ''
          mkdir -p $out/share/dopamine
          cp -r release/linux*unpacked/{locales,resources{,.pak}} $out/share/dopamine

          makeWrapper ${lib.getExe electron} $out/bin/dopamine \
            --add-flags $out/share/dopamine/resources/app.asar \
            --inherit-argv0

          for size in 16 24 32 48 64 96 128 256 512; do
            install -Dm644 "build/icons/"$size"x"$size".png" "$out/share/icons/hicolor/"$size"x"$size"/apps/dopamine.png"
          done

          install -Dm644 deployment/AUR/Dopamine.desktop $out/share/applications/dopamine.desktop
        ''
    }

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/digimezzo/dopamine/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Audio player that keeps it simple";
    homepage = "https://github.com/digimezzo/dopamine";
    license = lib.licenses.gpl3Only;
    mainProgram = "dopamine";
    maintainers = with lib.maintainers; [
      Guanran928
      ern775
    ];
    platforms = lib.platforms.all;
  };
})
