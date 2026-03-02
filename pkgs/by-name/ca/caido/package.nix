{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  autoPatchelfHook,
  _7zz,
  unzip,
  libgcc,
  appVariants ? [ ],
}:
let
  pname = "caido";
  appVariantList = [
    "cli"
    "desktop"
  ];
  version = "0.55.1";

  system = stdenv.hostPlatform.system;
  isLinux = stdenv.isLinux;
  isDarwin = stdenv.isDarwin;

  # CLI sources
  cliSources = {
    x86_64-linux = {
      url = "https://caido.download/releases/v${version}/caido-cli-v${version}-linux-x86_64.tar.gz";
      hash = "sha256-4xRkEN/ZA+JUFMB2qoEZT0Bzv2Qc7Y9kcj251MCAhKE=";
    };
    aarch64-linux = {
      url = "https://caido.download/releases/v${version}/caido-cli-v${version}-linux-aarch64.tar.gz";
      hash = "sha256-gMQkF0+mq2nRBy0oBenFvp69byWCkqmt8E4ZpKuNxKw=";
    };
    x86_64-darwin = {
      url = "https://caido.download/releases/v${version}/caido-cli-v${version}-mac-x86_64.zip";
      hash = "sha256-C+EfmSBJMyxYXLfzxCrY7ZVtg8nwtie8w0Lj1Dy7o/k=";
    };
    aarch64-darwin = {
      url = "https://caido.download/releases/v${version}/caido-cli-v${version}-mac-aarch64.zip";
      hash = "sha256-b0cBS3RwsiLgJNqHWxi672MVZNfTYNOEJ2k0h2qNnP0=";
    };
  };

  # Desktop sources
  desktopSources = {
    x86_64-linux = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-linux-x86_64.AppImage";
      hash = "sha256-zfts2h8QWTxe/dISwgKRQiSx2nD6vtE1atPfREyGX/U=";
    };
    aarch64-linux = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-linux-aarch64.AppImage";
      hash = "sha256-fYqzukRptCB466LIPbVre2EwBFt4Bsq9amQ4kjQuV2Q=";
    };
    x86_64-darwin = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-mac-x86_64.dmg";
      hash = "sha256-UsGT5n0MGVwWCXACo74Harb4J/qt/3TyD0+EFYNmPxw=";
    };
    aarch64-darwin = {
      url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-mac-aarch64.dmg";
      hash = "sha256-iZHZayj2VYjMY9+p+xrlX+vP/DcbCRPQizQEqtF39EU=";
    };
  };

  cliSource = cliSources.${system} or (throw "Unsupported system for caido-cli: ${system}");
  desktopSource =
    desktopSources.${system} or (throw "Unsupported system for caido-desktop: ${system}");

  cli = fetchurl {
    url = cliSource.url;
    hash = cliSource.hash;
  };

  desktop = fetchurl {
    url = desktopSource.url;
    hash = desktopSource.hash;
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version;
    src = desktop;
  };

  wrappedDesktop =
    if isLinux then
      appimageTools.wrapType2 {
        src = desktop;
        inherit pname version;

        nativeBuildInputs = [ makeWrapper ];

        extraPkgs = pkgs: [ pkgs.libthai ];

        extraInstallCommands = ''
          install -m 444 -D ${appimageContents}/caido.desktop -t $out/share/applications
          install -m 444 -D ${appimageContents}/caido.png \
            $out/share/icons/hicolor/512x512/apps/caido.png
          wrapProgram $out/bin/caido \
            --set WEBKIT_DISABLE_COMPOSITING_MODE 1 \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
        '';
      }
    else if isDarwin then
      stdenv.mkDerivation {
        src = desktop;
        inherit pname version;

        nativeBuildInputs = [ _7zz ];
        sourceRoot = ".";

        unpackPhase = ''
          runHook preUnpack
          ${_7zz}/bin/7zz x $src
          runHook postUnpack
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/Applications
          cp -r Caido.app $out/Applications/
          mkdir -p $out/bin
          ln -s $out/Applications/Caido.app/Contents/MacOS/Caido $out/bin/caido
          runHook postInstall
        '';

        meta = {
          platforms = [
            "x86_64-darwin"
            "aarch64-darwin"
          ];
        };
      }
    else
      throw "Desktop variant is not supported on ${stdenv.hostPlatform.system}";

  wrappedCli =
    if isLinux then
      stdenv.mkDerivation {
        src = cli;
        inherit pname version;

        nativeBuildInputs = [ autoPatchelfHook ];
        buildInputs = [ libgcc ];
        sourceRoot = ".";

        installPhase = ''
          runHook preInstall
          install -m755 -D caido-cli $out/bin/caido-cli
          runHook postInstall
        '';
      }
    else if isDarwin then
      stdenv.mkDerivation {
        src = cli;
        inherit pname version;

        nativeBuildInputs = [ unzip ];
        sourceRoot = ".";

        installPhase = ''
          runHook preInstall
          install -m755 -D caido-cli $out/bin/caido-cli
          runHook postInstall
        '';

        meta = {
          platforms = [
            "x86_64-darwin"
            "aarch64-darwin"
          ];
        };
      }
    else
      throw "CLI variant is not supported on ${stdenv.hostPlatform.system}";

  meta = {
    description = "Lightweight web security auditing toolkit";
    homepage = "https://caido.io/";
    changelog = "https://github.com/caido/caido/releases/tag/v${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      octodi
      blackzeshi
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
in
lib.checkListOfEnum "${pname}: appVariants" appVariantList appVariants (
  if appVariants == [ "desktop" ] then
    wrappedDesktop
  else if appVariants == [ "cli" ] then
    wrappedCli
  else
    stdenv.mkDerivation {
      inherit pname version meta;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        ln -s ${wrappedDesktop}/bin/caido $out/bin/caido
        ln -s ${wrappedCli}/bin/caido-cli $out/bin/caido-cli
      '';
    }
)
