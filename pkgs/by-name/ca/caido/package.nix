{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  autoPatchelfHook,
  libgcc,
  appVariants ? [ ],
}:

let
  pname = "caido";
  appVariantList = [
    "cli"
    "desktop"
  ];
  version = "0.42.0";
  cli = fetchurl {
    url = "https://caido.download/releases/v${version}/caido-cli-v${version}-linux-x86_64.tar.gz";
    hash = "sha256-Y0ygbdL9IKvTRLwR0oW1LjFQZfPxKOoZnSDV2zgtJjM=";
  };
  desktop = fetchurl {
    url = "https://caido.download/releases/v${version}/caido-desktop-v${version}-linux-x86_64.AppImage";
    hash = "sha256-zS/lbcXK1iN2tuUMWc6Us0q2eUypD8mXsw0C+QKE3+w=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version;
    src = desktop;
  };

  wrappedDesktop = appimageTools.wrapType2 {
    src = desktop;
    inherit pname version;

    nativeBuildInputs = [ makeWrapper ];

    extraPkgs = pkgs: [ pkgs.libthai ];

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/caido.desktop -t $out/share/applications
      install -m 444 -D ${appimageContents}/caido.png \
        $out/share/icons/hicolor/512x512/apps/caido.png
      wrapProgram $out/bin/caido \
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    '';
  };

  wrappedCli = stdenv.mkDerivation {
    src = cli;
    inherit pname version;

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [ libgcc ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -m755 -D caido-cli $out/bin/caido-cli
    '';
  };

  meta = {
    description = "Lightweight web security auditing toolkit";
    homepage = "https://caido.io/";
    changelog = "https://github.com/caido/caido/releases/tag/v${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      octodi
      d3vil0p3r
    ];
    platforms = [ "x86_64-linux" ];
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
