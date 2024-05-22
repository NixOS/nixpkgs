{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  substituteAll,
  pandoc,
  electron,
}:
let
  platformIds = {
    "x86_64-linux" = "linux";
    "aarch64-linux" = "linux"; # change linux-arm64 when updating to version >=3.0.17
    "x86_64-darwin" = "darwin";
    "aarch64-darwin" = "darwin-arm64";
  };

  platformId = platformIds.${stdenv.system} or (throw "Unsupported platform: ${stdenv.system}");

  electronDist = electron + (if stdenv.isDarwin then "/Applications" else "/libexec/electron");
in
buildNpmPackage rec {
  pname = "siyuan";
  version = "3.0.11";

  src = fetchFromGitHub {
    owner = "siyuan-note";
    repo = "siyuan";
    rev = "v${version}";
    hash = "sha256-s82g5os944us85V2TBnm+HNd37vVzNjaOJYrbBrgLSI=";
  };

  kernel = buildGoModule {
    name = "${pname}-${version}-kernel";
    inherit src;
    sourceRoot = "${src.name}/kernel";
    vendorHash = "sha256-onZBrw0fDsjqXgQF06C40ArxNmsbFDIwD57fJ0jB0ls=";

    patches = [
      (substituteAll {
        src = ./set-pandoc-path.patch;
        pandoc_path = lib.getExe pandoc;
      })
    ];

    # this patch makes it so that file permissions are not kept when copying files using the gulu package
    # this fixes a problem where it was copying files from the store and keeping their permissions
    # hopefully this doesn't break other functionality
    modPostBuild = ''
      chmod +w vendor/github.com/88250/gulu
      substituteInPlace vendor/github.com/88250/gulu/file.go \
          --replace-fail "os.Chmod(dest, sourceinfo.Mode())" "os.Chmod(dest, 0644)"
    '';

    flags = [ "fts5" ];

    ldflags = [
      "-s"
      "-w"
    ];
  };

  sourceRoot = "${src.name}/app";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json

    mkdir kernel-${platformId}
    ln -s ${kernel}/bin/kernel kernel-${platformId}/SiYuan-Kernel

    # for some reason the default page is broken, use the redirection link automatically
    substituteInPlace electron/main.js \
        --replace-fail '"/stage/build/app/index.html?v=" + new Date().getTime()' '"/stage/build/desktop"'

    # remove prebuilt pandoc archives
    rm -r pandoc
  '';

  npmDepsHash = "sha256-Yv/iOCyry3CNeKPxS206Y5y5mvzPU873PJdi0UQkVLs=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # disable code signing on Darwin
  env.CSC_IDENTITY_AUTO_DISCOVERY = "false";

  npmBuildScript = "build:desktop";

  postBuild = ''
    cp -r ${electronDist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
        --dir \
        --config electron-builder-${platformId}.yml \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString (!stdenv.isDarwin) ''
      mkdir -p $out/share/siyuan
      cp -r build/*-unpacked/{locales,resources{,.pak}} $out/share/siyuan

      makeWrapper ${lib.getExe electron} $out/bin/siyuan \
          --chdir $out/share/siyuan/resources \
          --add-flags $out/share/siyuan/resources/app \
          --set ELECTRON_FORCE_IS_PACKAGED 1 \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
          --inherit-argv0
    ''}

    ${lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/Applications
      cp -r build/mac*/SiYuan.app $out/Applications
      makeWrapper $out/Applications/SiYuan.app/Contents/MacOS/SiYuan $out/bin/siyuan
    ''}

    runHook postInstall
  '';

  meta = {
    description = "A privacy-first personal knowledge management system that supports complete offline usage, as well as end-to-end encrypted data sync";
    homepage = "https://b3log.org/siyuan/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "siyuan";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.attrNames platformIds;
  };
}
