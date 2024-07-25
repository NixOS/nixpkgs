{ lib
, stdenv
, fetchgit
, goocanvas
, pkg-config
, gtk2
, libxml2
, curl
, libmicrohttpd
, libzip
, libusb1
, qrencode
, json-glib
, php82
, libwebsockets
, openssl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bellepoule";
  version = "5.4";

  src = (fetchgit {
    url = "https://git.launchpad.net/bellepoule";
    rev = finalAttrs.version;
    hash = "sha256-PFSbmdzqfB2rNtLGcQWfw73Ja9CC4z4Z588oKj4gRSE=";
  }).overrideAttrs (_: {
    GIT_CONFIG_COUNT = 1;
    GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
    GIT_CONFIG_VALUE_0 = "git@github.com:";
  });

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk2
    libxml2
    curl
    libmicrohttpd
    goocanvas
    qrencode
    openssl
    json-glib
    libzip
    libusb1
    libwebsockets
  ];

  patches = [
    # Add placeholder Twitter / Facebook credentials.
    ./empty-advertiser_ids.patch
    # webkit-1.0 is optional and can be disabled in the MakeFile (only used for Twitter / Facebook authorization).
    ./remove-webkit.patch
  ];

  # Use system php
  postPatch = ''
    sed -i -e "s#php7.0#${php82}/bin/php#g" ./sources/common/network/web_server.cpp
  '';

  # Prepare release directory for buildPhase
  preBuild = ''
    cd build/BellePoule
    make HOME=$(pwd) DISTRIB=nixos V=1 package
    cd ./Project/PPA/${finalAttrs.pname}/${finalAttrs.pname}_${finalAttrs.version}
  '';

  buildPhase = ''
    runHook preBuild
    make HOME=$(pwd) DISTRIB=nixos V=1 all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make HOME=$(pwd) DISTRIB=nixos V=1 DESTDIR=$out install
    runHook postInstall
  '';

  # FixUp MakeFile output path
  fixupPhase = ''
    runHook preFixup
    mv $out/usr/* $out
    rmdir $out/usr
    runHook postFixup
  '';

  meta = with lib; {
    description = "Fencing tournaments management software";
    homepage = "http://betton.escrime.free.fr";
    changelog = "https://git.launchpad.net/bellepoule/log/?h=${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tgi74 ];
    platforms = platforms.linux;
    mainProgram = "bellepoule-supervisor";
  };
})
