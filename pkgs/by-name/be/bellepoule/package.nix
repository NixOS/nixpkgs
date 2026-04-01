{
  lib,
  stdenv,
  fetchgit,
  goocanvas_1,
  pkg-config,
  gtk2,
  libxml2,
  curl,
  libmicrohttpd,
  libzip,
  libusb1,
  qrencode,
  json-glib,
  php,
  libwebsockets,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bellepoule";
  version = "5.5";

  src =
    (fetchgit {
      url = "https://git.launchpad.net/bellepoule";
      rev = finalAttrs.version;
      hash = "sha256-SNL6yaaKk/GU8+EvHki4ysMuCHEQxFjPd3iwVIdJtCs=";
    }).overrideAttrs
      (oldAttrs: {
        env = oldAttrs.env or { } // {
          GIT_CONFIG_COUNT = 1;
          GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
          GIT_CONFIG_VALUE_0 = "git@github.com:";
        };
      });

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk2
    libxml2
    curl
    libmicrohttpd
    goocanvas_1
    qrencode
    openssl
    json-glib
    libzip
    libusb1
    libwebsockets
  ];

  makeFlags = [
    "HOME=$(pwd)"
    "DISTRIB=nixos"
    "V=1"
    "DESTDIR=$(out)"
  ];

  # Use system php
  # Disable git soft depend
  # Disable dch changelog generation
  # FixUp `install` phase output
  postPatch = ''
    substituteInPlace ./sources/common/network/web_server.cpp --replace-fail "php7.4" "${php}/bin/php"
    substituteInPlace ./build/BellePoule/debian/bellepoule.desktop.template --replace-fail "/usr" "$out"
    substituteInPlace ./build/BellePoule/Makefile \
      --replace-fail "git" "#git" \
      --replace-fail "dch" "echo Ignoring: dch" \
      --replace-fail "/usr" ""
  '';

  # Prepare release directory for buildPhase
  preBuild = ''
    cd build/BellePoule
    make HOME=$(pwd) DISTRIB=nixos V=1 package
    cd ./Perso/PPA/${finalAttrs.pname}/${finalAttrs.pname}_${finalAttrs.version}
  '';

  meta = {
    description = "Fencing tournaments management software";
    homepage = "http://betton.escrime.free.fr";
    changelog = "https://git.launchpad.net/bellepoule/log/?h=${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tgi74 ];
    platforms = lib.platforms.linux;
    mainProgram = "bellepoule-supervisor";
  };
})
