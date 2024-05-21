{
  lib,
  fetchFromGitHub,
  buildGoModule,
  buildNpmPackage,
  substituteAll,
  pandoc,
  electron,
}:

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
  };

  sourceRoot = "${src.name}/app";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
    # for some reason the default page is broken, use the redirection link automatically
    substituteInPlace electron/main.js \
        --replace-fail ' "/stage/build/app/index.html?v=" + new Date().getTime()' '"/stage/build/desktop"'
  '';

  npmDepsHash = "sha256-Yv/iOCyry3CNeKPxS206Y5y5mvzPU873PJdi0UQkVLs=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "build:desktop";

  postBuild = ''
    substituteInPlace electron-builder-linux.yml \
        --replace-fail '- target: "AppImage"' "" \
        --replace-fail '- target: "tar.gz"' '- target: "dir"'

    # add extra fields to resolve the electron provided by nixpkgs
    sed -e 1i'electronDist: ${electron}/libexec/electron' \
        -e 1i'electronVersion: ${electron.version}' \
        -i electron-builder-linux.yml

    npm run dist-linux
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/siyuan
    cp -r build/*-unpacked/{locales,resources{,.pak}} $out/share/siyuan

    mkdir $out/share/siyuan/resources/kernel
    ln -s ${kernel}/bin/kernel $out/share/siyuan/resources/kernel/SiYuan-Kernel

    makeWrapper ${lib.getExe electron} $out/bin/siyuan \
        --chdir $out/share/siyuan/resources \
        --add-flags $out/share/siyuan/resources/app \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --inherit-argv0

    runHook postInstall
  '';

  meta = {
    description = "A privacy-first personal knowledge management system that supports complete offline usage, as well as end-to-end encrypted data sync";
    homepage = "https://b3log.org/siyuan/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "siyuan";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
}
