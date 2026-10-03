{
  stdenv,
  lib,
  fetchurl,
  autoconf,
  automake,
  libtool,
  pkg-config,
  boost,
  libuuid,
  apr,
  openssl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "activemq-cpp";
  version = "3.9.5";

  src = fetchurl {
    url = "mirror://apache/activemq/activemq-cpp/${finalAttrs.version}/activemq-cpp-library-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-WFgQbyG7VB1aOUeQZzGiGHsA3JGHD6TgKGagPpi+opI=";
  };

  buildInputs = [
    boost
    libuuid
    apr
    openssl
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  postInstall = ''
    ln -s $out/include/activemq-cpp-${finalAttrs.version}/* $out/include/
  '';

  meta = {
    homepage = "https://activemq.apache.org/";
    description = "ActiveMQ CPP is a messaging library that can use multiple protocols to talk to a MOM (e.g. ActiveMQ).";
    license = lib.licenses.asl20;
    mainProgram = "activemqcpp-config";
    maintainers = [ lib.maintainers.rucadi ];
    platforms = lib.platforms.unix;
  };

  strictDeps = true;
  __structuredAttrs = true;
})
