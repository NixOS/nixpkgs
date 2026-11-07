{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  fontconfig,
  libGL,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  writeShellApplication,
  curl,
  gnugrep,
  gnused,
  gnutar,
  gzip,
  jq,
  nix,
  nix-update-script,
  _experimental-update-script-combinators,
}:

let
  skiaBinaries = fetchurl {
    url = "https://github.com/rust-skia/skia-binaries/releases/download/0.157.0/skia-binaries-30669978c3f39a73e8a7-aarch64-apple-darwin-ganesh-gl-jpegd-jpege-metal-pdf.tar.gz";
    hash = "sha256-5KqI9oR67ykuqy3Mra93xocL4kqJIexzhBVXlahG+Uw=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "browsers";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "Browsers-software";
    repo = "browsers";
    tag = finalAttrs.version;
    hash = "sha256-F4a20k+7AG+W9zU/WrLoDofAzzFjaRwpWUhq9zYqeiw=";
  };

  cargoHash = "sha256-oYp9hTdwLeoWiOaelurDBBnCdzntdnKzoQrdxmx8SWY=";

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      rustPlatform.bindgenHook
    ];

  env =
    lib.optionalAttrs stdenv.hostPlatform.isLinux {
      GETTEXT_SYSTEM = "1";
    }
    // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
      SKIA_BINARIES_URL = "file://${skiaBinaries}";
    };

  postInstall =
    if stdenv.hostPlatform.isLinux then
      ''
        mkdir -p $out/resources
        cp -r resources/i18n resources/icons resources/repository $out/resources

        install -m 444 -D extra/linux/dist/software.Browsers.template.desktop \
            $out/share/applications/software.Browsers.desktop
        substituteInPlace $out/share/applications/software.Browsers.desktop \
            --replace-fail 'Exec=€ExecCommand€' 'Exec=${finalAttrs.meta.mainProgram} %u'

        for size in 16 32 64 128 256 512; do
          install -m 444 -D resources/icons/"$size"x"$size"/software.Browsers.png \
              -t $out/share/icons/hicolor/"$size"x"$size"/apps
        done
      ''
    else if stdenv.hostPlatform.isDarwin then
      ''
        app=$out/Applications/Browsers.app
        mkdir -p $app/Contents/MacOS $app/Contents/Resources

        substitute extra/macos/Info.plist $app/Contents/Info.plist \
            --replace-fail '$CFBundleShortVersion$' '${finalAttrs.version}' \
            --replace-fail '$CFBundleVersion$' '${finalAttrs.version}'

        install -m 444 -D extra/macos/icons/Browsers.icns $app/Contents/Resources/Browsers.icns
        cp -r resources/i18n resources/icons resources/repository $app/Contents/Resources

        mv $out/bin/browsers $app/Contents/MacOS/Browsers
        ln -s $app/Contents/MacOS/Browsers $out/bin/browsers
      ''
    else
      throw "Unsupported platform ${stdenv.hostPlatform.system}";

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        fontconfig
        libGL
        libxkbcommon
        wayland
        libx11
        libxcursor
        libxi
        libxrandr
      ]
    } $out/bin/browsers
  '';

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    (lib.getExe (writeShellApplication {
      name = "browsers-update-skia";
      runtimeInputs = [
        curl
        gnugrep
        gnused
        gnutar
        gzip
        jq
        nix
      ];
      text = ''
        pkgFile=${toString ./package.nix}

        src=$(nix-build --no-out-link -A "$UPDATE_NIX_ATTR_PATH.src")
        skiaVersion=$(grep -A1 '^name = "skia-bindings"$' "$src/Cargo.lock" | sed -nE 's/^version = "(.*)"$/\1/p')
        skiaCommit=$(
          curl -fsSL "https://static.crates.io/crates/skia-bindings/skia-bindings-$skiaVersion.crate" \
            | tar -xzO "skia-bindings-$skiaVersion/.cargo_vcs_info.json" \
            | jq -r '.git.sha1[:20]'
        )
        sed -i -E "s|/download/[^/]+/skia-binaries-[0-9a-f]+-|/download/$skiaVersion/skia-binaries-$skiaCommit-|" "$pkgFile"
        url=$(sed -nE 's|^    url = "(https://github.com/rust-skia/.*)";$|\1|p' "$pkgFile")
        hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url "$url")")
        sed -i -E "\\|$url|{n;s|hash = \".*\"|hash = \"$hash\"|}" "$pkgFile"
      '';
    }))
  ];

  meta = {
    description = "Open the right browser at the right time";
    homepage = "https://browsers.software";
    changelog = "https://github.com/Browsers-software/browsers/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ ravenz46 ];
    mainProgram = "browsers";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
