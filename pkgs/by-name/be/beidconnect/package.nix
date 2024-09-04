{
  lib,
  stdenv,
  fetchFromGitHub,
  pcsclite,
  boost,
  pkg-config,
  testers,
  beidconnect,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "beidconnect";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "Fedict";
    repo = "fts-beidconnect";
    rev = finalAttrs.version;
    hash = "sha256-xkBldXOlgLMgrvzm7ajXzJ92mpXrxHD1RX4DeBxU3kk=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    pcsclite.dev
    boost
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(DESTDIR)/usr/bin' '$(DESTDIR)/bin'
  '';

  makeFlags = [ "DESTDIR=$(out)" ];
  sourceRoot = "${finalAttrs.src.name}/linux";

  postInstall = ''
    install -d \
      $out/etc/chromium/native-messaging-hosts \
      $out/etc/opt/chrome/native-messaging-hosts/ \
      $out/etc/opt/edge/native-messaging-hosts/ \
      $out/etc/opt/vivaldi/native-messaging-hosts/ \
      $out/etc/opt/brave/native-messaging-hosts/ \
      $out/lib/mozilla/native-messaging-hosts \

    $out/bin/beidconnect -setup $out/bin \
      $out/etc/chromium/native-messaging-hosts \
      $out/lib/mozilla/native-messaging-hosts

    # Chrome
    install $out/etc/chromium/native-messaging-hosts/be.bosa.beidconnect.json $out/etc/opt/chrome/native-messaging-hosts/

    # Edge
    install $out/etc/chromium/native-messaging-hosts/be.bosa.beidconnect.json $out/etc/opt/edge/native-messaging-hosts/

    # Vivaldi
    install $out/etc/chromium/native-messaging-hosts/be.bosa.beidconnect.json $out/etc/opt/vivaldi/native-messaging-hosts/

    # Brave
    install $out/etc/chromium/native-messaging-hosts/be.bosa.beidconnect.json $out/etc/opt/brave/native-messaging-hosts/
  '';

  passthru.tests.version = testers.testVersion {
    package = beidconnect;
    command = "${beidconnect}/bin/beidconnect -version";
  };

  meta = {
    description = "BeIDConnect native messaging component";
    longDescription = ''
      The beidconnect is a program to help implementing digital signing services
      and/or an identity service using the Belgian eID card. It provides
      services to webbrowsers to read data from cards, and is intended to work
      together with a WebExtension in the browser.

      This package contains the native code. For the WebExtension, see your
      webbrowser's extension store.
    '';
    homepage = "https://github.com/Fedict/fts-beidconnect/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jovandeginste ];
    platforms = lib.platforms.linux;
  };
})
