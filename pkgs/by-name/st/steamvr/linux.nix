{
  lib,
  stdenvNoCC,
  fetchSteam,
  autoPatchelfHook,
  audit,
  bzip2,
  expat,
  gtk2,
  gdk-pixbuf,
  glib,
  glibc,
  libdrm,
  libgcc,
  libpng12,
  libGL,
  libusb1,
  nspr,
  nss,
  openal,
  SDL2,
  vulkan-loader,
  xorg,
  zlib,
  readline63,
  rsync,
  config,
  acceptLicense ?
    config.steam.acceptSubscriberAgreement or config.steam.acceptPCCafeAgreement
      or config.steamvr.acceptCommercialLicense or true, # TODO: Change true to false once debugged
}:

stdenvNoCC.mkDerivation {
  name = "steamvr-linux";

  srcs =
    assert
      !acceptLicense
      -> throw ''
        Use of SteamVR requires the acceptance of at least one of the following license agreements:

          - Steam Subscriber Agreement [1]
          - Steam PC Café Agreement [2]
          - SteamVR Commercial License Agreement [3]

        You can express acceptance by setting one of the following options:

        configuration.nix:
          nixpkgs.config.steam.acceptSubscriberAgreement = true; # for the Steam Subscriber Agreement
          nixpkgs.config.steam.acceptPCCafeAgreement = true; # for the Steam PC Café Agreement
          nixpkgs.config.steamvr.acceptCommercialLicense = true; # for the SteamVR Commercial License Agreement

        [1]: https://store.steampowered.com/subscriber_agreement/
        [2]: https://partner.steamgames.com/doc/sitelicense/licensees/signup
        [3]: https://partner.steamgames.com/doc/features/steamvr/enterprise
      '';
    [
      (fetchSteam {
        name = "steamvr-linux-depot";
        app = 250820;
        depot = 250823;
        manifest = 5747149350848671194;
        hash = "sha256-q3jasX/prYhs+Vs7Ofru2N3WVxf/0tGlqTd5SvKRm10=";
      })
      (fetchSteam {
        name = "openvr-content-1-depot";
        app = 250820;
        depot = 250824;
        manifest = 5862217504045387455;
        hash = "sha256-X4vQdfrbkqkDk+zWeZ9uq0aqa3EDzrUAsMAzQGLhmo8=";
      })
      (fetchSteam {
        name = "openvr-content-2-depot";
        app = 250820;
        depot = 250827;
        manifest = 2950592113021695594;
        hash = "sha256-5P8FRXAe2ZUsEQxtdVQLjvq8YHWqG1xY6paRDF8fHtc=";
      })
      (fetchSteam {
        name = "openvr-content-3-depot";
        app = 250820;
        depot = 250828;
        manifest = 7972087267127211047;
        hash = "sha256-nsrYx+/pba38ucDaEXOhrQeTHERegHUSv3MjiOhUdjg=";
      })
      (fetchSteam {
        name = "openvr-content-4-depot";
        app = 250820;
        depot = 250829;
        manifest = 1180860512328011191;
        hash = "sha256-yf6aSyQ0r1RoFEp5aK9yNPbMN5lZEkLG1Gmr1ffLEsA=";
      })
      (fetchSteam {
        name = "steamvr-environments-linux-depot";
        app = 250820;
        depot = 250829;
        manifest = 1180860512328011191;
        hash = "sha256-yf6aSyQ0r1RoFEp5aK9yNPbMN5lZEkLG1Gmr1ffLEsA=";
      })
    ];
  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    rsync
  ];
  buildInputs =
    [
      audit
      bzip2
      expat
      gtk2
      gdk-pixbuf
      glib
      glibc
      libdrm
      libgcc.lib
      libpng12
      libGL
      libusb1
      nspr
      nss
      openal
      readline63
      SDL2
      vulkan-loader
      zlib
    ]
    ++ (with xorg; [
      libX11
      libXext
      libXrender
      libXi
      libXtst
      libXdamage
      libSM
    ]);

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    for src in $srcs; do
      rsync -a $src/ $out/
    done
  '';
}
