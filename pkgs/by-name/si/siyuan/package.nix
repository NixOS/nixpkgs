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
  platformId =
    {
      "x86_64-linux" = "linux";
      "aarch64-linux" = "linux-arm64";
    }
    .${stdenv.system} or (throw "Unsupported platform: ${stdenv.system}");
in
buildNpmPackage rec {
  pname = "siyuan";
  version = "3.0.17";

  src = fetchFromGitHub {
    owner = "siyuan-note";
    repo = "siyuan";
    rev = "v${version}";
    hash = "sha256-tTFoSftl8u9ZRBH+74yMsaTH0WMCqybIpnul0pb9F0E=";
  };

  kernel = buildGoModule {
    name = "${pname}-${version}-kernel";
    inherit src;
    sourceRoot = "${src.name}/kernel";
    vendorHash = "sha256-jEy16IdgLPT+Om0rZkjpp1lwFKmVVjzlQ/3IOtPSjmA=";

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

    mkdir kernel-${platformId}
    ln -s ${kernel}/bin/kernel kernel-${platformId}/SiYuan-Kernel

    # for some reason the default page is broken, use the redirection link automatically
    substituteInPlace electron/main.js \
        --replace-fail ' "/stage/build/app/index.html?v=" + new Date().getTime()' '"/stage/build/desktop"'
  '';

  npmDepsHash = "sha256-R09EcegN/4l9nblWgiGcwg/IeNZDeMtk0bSnw80QEiA=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "build:desktop";

  postBuild = ''
    npm exec electron-builder -- \
        --dir \
        --config electron-builder-${platformId}.yml \
        -c.electronDist=${electron}/libexec/electron \
        -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/siyuan
    cp -r build/*-unpacked/{locales,resources{,.pak}} $out/share/siyuan

    makeWrapper ${lib.getExe electron} $out/bin/siyuan \
        --chdir $out/share/siyuan/resources \
        --add-flags $out/share/siyuan/resources/app \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --inherit-argv0

    runHook postInstall
  '';

  meta = {
    description = "Privacy-first personal knowledge management system that supports complete offline usage, as well as end-to-end encrypted data sync";
    homepage = "https://b3log.org/siyuan/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "siyuan";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
}
