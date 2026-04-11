{
  fetchFromGitHub,
  lib,
  makeWrapper,
  pkgsCross,
  replaceVars,
  rustPlatform,
  steam,
  symlinkJoin,
}:

let
  version = "0.11.0";

  # me3 creates a pipe under /tmp needed by the compat tool subprocess
  steam-run =
    (steam.override {
      privateTmp = false;
    }).run-free;

  src = fetchFromGitHub {
    owner = "garyttierney";
    repo = "me3";
    tag = "v${version}";
    sha256 = "sha256-XyeMVPGzNF2syipLz9HPtUg7lhxcEq434FnRH3Ax+HM=";
  };

  cargoHash = "sha256-T1HeYe9FUC5oy/SDeEd6vV4D9YIGIXMkbzf43gRNyt8=";

  me3-cli = rustPlatform.buildRustPackage (final: {
    inherit cargoHash version src;
    pname = "me3-cli";

    # Wrap the compat tool subprocess to support proton's pressure vessel
    patches = [
      (replaceVars ./steam-run.patch {
        steamRun = lib.getExe steam-run;
      })
    ];

    cargoBuildFlags = [
      "--package"
      "me3-cli"
    ];

    cargoTestFlags = final.cargoBuildFlags;

    postInstall = ''
      install -Dm444 distribution/linux/me3-launch.desktop \
        $out/share/applications/me3-launch.desktop
      install -Dm444 distribution/linux/me3.xml \
        $out/share/mime/packages/me3.xml
      install -Dm444 distribution/assets/me3.png \
        $out/share/icons/hicolor/128x128/apps/me3.png
    '';
  });

  me3-windows = pkgsCross.mingwW64.rustPlatform.buildRustPackage (final: {
    inherit cargoHash version src;
    pname = "me3-windows";

    CARGO_TARGET_X86_64_PC_WINDOWS_GNU_RUSTFLAGS = "-Clink-arg=-lmcfgthread";
    RUSTC_BOOTSTRAP = 1;

    cargoBuildFlags = [
      "--package"
      "me3-launcher"
      "--package"
      "me3-mod-host"
    ];

    cargoTestFlags = final.cargoBuildFlags;

    # Remove useless libme3_mod_host.dll.a
    postInstall = ''
      rm -r $out/lib
    '';
  });
in
symlinkJoin {
  inherit version;
  name = "me3";

  paths = [
    me3-cli
    me3-windows
  ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/me3 \
      --set WINEPATH $out/bin \
      --add-flags "--windows-binaries-dir $out/bin"
  '';

  meta = {
    description = "Framework for modding and instrumenting games.";
    homepage = "https://github.com/garyttierney/me3";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.icedborn ];
  };
}
