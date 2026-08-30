{
  lib,
  stdenv,
  fetchurl,
  unzip,
  buildFHSEnv,
  copyDesktopItems,
  makeDesktopItem,
  writeShellScript,
  alsa-lib,
  atk,
  cairo,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  nspr,
  nss,
  pango,
  pcsclite,
  procps,
  zlib,
}:

let
  pname = "ncalayer";
  version = "1.4";

  src = fetchurl {
    # Upstream updates the application by overwriting this static file
    # without providing a versioned archive or changelog.
    # A specific snapshot from Web Archive is pinned to guarantee reproducibility.
    url = "https://web.archive.org/web/20260709073222/https://ncl.pki.gov.kz/images/NCALayer/ncalayer.zip";
    hash = "sha256-MfR8Em/lYQfXbxHERhEN+gn8OX8DKlTvjuTXvK9kYcs=";
  };

  ncalayer-unwrapped = stdenv.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version src;

    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = [
      unzip
      copyDesktopItems
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/ncalayer
      cp -r additions ncalayer.sh $out/share/ncalayer/

      mkdir -p $out/share/pixmaps
      cp additions/ncalayer.png $out/share/pixmaps/

      chmod +x $out/share/ncalayer/additions/showSettings
      chmod +x $out/share/ncalayer/additions/showBundleManager
      chmod +x $out/share/ncalayer/additions/jre8_ncalayer/bin/*
      chmod +x $out/share/ncalayer/ncalayer.sh

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "ncalayer";
        desktopName = "NCALayer";
        genericName = "Digital Signature Client";
        comment = "NCALayer digital signature application (Kazakhstan)";
        icon = "ncalayer";
        exec = "ncalayer --run";
        terminal = false;
        categories = [
          "Network"
          "RemoteAccess"
        ];
      })
      (makeDesktopItem {
        name = "ncalayer-settings";
        desktopName = "NCALayer Settings";
        genericName = "NCALayer Configuration";
        comment = "Open NCALayer configuration window";
        icon = "ncalayer";
        exec = "ncalayer --settings";
        terminal = false;
        categories = [
          "Settings"
          "Network"
        ];
      })
      (makeDesktopItem {
        name = "ncalayer-bundle-manager";
        desktopName = "NCALayer Bundle Manager";
        genericName = "NCALayer Modules";
        comment = "Manage NCALayer plugins and modules";
        icon = "ncalayer";
        exec = "ncalayer --bundle-manager";
        terminal = false;
        categories = [
          "Settings"
          "Network"
        ];
      })
    ];
  };

  fhsEnv = buildFHSEnv {
    name = pname;
    inherit version;

    targetPkgs = pkgs: [
      alsa-lib
      atk
      cairo
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libx11
      libxext
      libxi
      libxrender
      libxtst
      nspr
      nss
      pango
      pcsclite
      procps
      stdenv.cc.cc.lib
      zlib
    ];

    runScript = writeShellScript "ncalayer-run" ''
      ncalayer_unwrapped="${ncalayer-unwrapped}"
      ${builtins.readFile ./ncalayer-run.sh}
    '';
  };

in
stdenv.mkDerivation {
  inherit pname version;

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${fhsEnv}/bin/${pname} $out/bin/${pname}

    mkdir -p $out/share/applications $out/share/pixmaps
    ln -s ${ncalayer-unwrapped}/share/applications/* $out/share/applications/
    ln -s ${ncalayer-unwrapped}/share/pixmaps/* $out/share/pixmaps/

    runHook postInstall
  '';

  meta = {
    description = "Digital signature client for Kazakhstan government portals";
    longDescription = ''
      NCALayer operates as a local HTTPS loopback server, allowing Kazakhstani
      government and banking portals to interact with crypto-tokens and sign documents.

      For the application to function properly, the National Certification Authority
      (NCA / НУЦ РК) root certificates must be imported into your browser's or
      system's trusted certificate store, otherwise web portals won't be able to
      establish a secure connection with the local NCALayer service.

      If you plan to use physical hardware tokens or smart-cards (like Kaztoken),
      make sure to enable the PCSC-Lite daemon by adding `services.pcscd.enable = true;`
      to your NixOS configuration.
    '';
    homepage = "https://ncl.pki.gov.kz/eng/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ndenissov ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ncalayer";
  };
}
