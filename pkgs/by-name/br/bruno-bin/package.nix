{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  makeWrapper,
  unzip,
  writeShellScript,
  nix-update,
  jq,
  common-updater-scripts,
}:

let
  pname = "bruno-bin";
  version = "4.3.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/usebruno/bruno/releases/download/v${version}/bruno_${version}_x86_64_linux.AppImage";
      hash = "sha256-PDhrEAf2bYdcNKKlAgY/utZcZuN0CaMW6+UYeIsegLs=";
    };
    aarch64-linux = {
      url = "https://github.com/usebruno/bruno/releases/download/v${version}/bruno_${version}_arm64_linux.AppImage";
      hash = "sha256-YEjDrrdmB8cd91WN7qg8/vnTPPJKY9qefFJoqxnRNGk=";
    };
    aarch64-darwin = {
      url = "https://github.com/usebruno/bruno/releases/download/v${version}/bruno_${version}_arm64_mac.zip";
      hash = "sha256-jYenwh9cRyPSaXXBEEJZLVv1A+Hch6pbup6AZ+VR0tw=";
    };
  };

  src = fetchurl {
    inherit
      (sources.${stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
      )
      url
      hash
      ;
  };

  passthru = {
    updateScript = writeShellScript "update-bruno-bin" ''
      ${lib.getExe nix-update} bruno-bin --override-filename pkgs/by-name/br/bruno-bin/package.nix
      latestVersion=$(nix eval --log-format raw --raw --file default.nix bruno-bin.version)
      if [[ "$latestVersion" == "$UPDATE_NIX_OLD_VERSION" ]]; then
        exit 0
      fi
      systems=$(nix eval --json -f . bruno-bin.meta.platforms | ${lib.getExe jq} --raw-output '.[]')
      for system in $systems; do
        hash=$(nix store prefetch-file --json $(nix eval --raw -f . bruno-bin.src.url --system "$system") | ${lib.getExe jq} --raw-output .hash)
        ${lib.getExe' common-updater-scripts "update-source-version"} bruno-bin $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
      done
    '';
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    inherit src;
  };

  meta = {
    description = "Prebuilt Bruno API client, including the proprietary features of the official build";
    homepage = "https://www.usebruno.com";
    changelog = "https://github.com/usebruno/bruno/releases/tag/v${version}";
    # the source is MIT, but the official binaries bundle closed-source code
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "bruno-bin";
    maintainers = with lib.maintainers; [ samirbgno ];
    platforms = builtins.attrNames sources;
  };

  linux = appimageTools.wrapType2 (finalAttrs: {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    nativeBuildInputs = [ makeWrapper ];

    extraInstallCommands = ''
      wrapProgram $out/bin/bruno-bin \
        --add-flags "--no-sandbox" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

      install -Dm444 ${finalAttrs.contents}/bruno.desktop $out/share/applications/bruno-bin.desktop
      substituteInPlace $out/share/applications/bruno-bin.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=bruno-bin' \
        --replace-fail 'Icon=bruno' 'Icon=bruno-bin'

      for icon in ${finalAttrs.contents}/usr/share/icons/hicolor/*/apps/bruno.png; do
        size=$(basename $(dirname $(dirname "$icon")))
        install -Dm444 "$icon" "$out/share/icons/hicolor/$size/apps/bruno-bin.png"
      done
    '';
  });

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    nativeBuildInputs = [
      makeWrapper
      unzip
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -R Bruno.app $out/Applications
      makeWrapper $out/Applications/Bruno.app/Contents/MacOS/Bruno $out/bin/bruno-bin

      runHook postInstall
    '';

    # the app is signed upstream, modifying it would break the signature
    dontFixup = true;
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
