{
  lib,
  stdenv,
  fetchFromCodeberg,
  fetchpatch,
  autoreconfHook,
  boost,
  fcgi,
  openssl,
  opensaml-cpp,
  log4shib,
  pkg-config,
  xercesc,
  xml-security-c,
  xml-tooling-c,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shibboleth-sp";
  version = "3.0.4.1";

  src = fetchFromCodeberg {
    owner = "Shibboleth";
    repo = "cpp-sp";
    tag = finalAttrs.version;
    hash = "sha256-ub3TFKbRJKyiNy5+t5Aaiwt29ibOuBx4WiDMV/5qZOE=";
  };

  # Upgrade to Clang 19 (and thereby LLVM19) causes `std::char_traits` to now be present,
  # making `char_traits` references ambiguous due to both `std` and `xmltooling` exporting this symbol,
  # and the file in question uses both `using namespace std;` and `using namespace xmltooling;`
  # The patches below result in `xmltooling` being removed.
  # As `char_traits` is a compile time construct, no runtime repercussions can stem from this.
  # See https://shibboleth.atlassian.net/browse/SSPCPP-998 for a related discussion.
  patches = lib.optionals (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "19") [
    (fetchpatch {
      name = "char-traits-ambig-1";
      url = "https://codeberg.org/Shibboleth/cpp-sp/commit/49cd05fa6d9935a45069fa555db7a26ca77d23db.diff";
      hash = "sha256-ZF0jsZJoHaxaPPjVbT6Wlq+wjyPQLTnEKcUxONji/hE=";
    })

    (fetchpatch {
      name = "char-traits-ambig-2";
      url = "https://codeberg.org/Shibboleth/cpp-sp/commit/793663a67aaa4e9a4aa9172728d924f8cec45cf6.diff";
      includes = [ "shibsp/util/IPRange.cpp" ];
      hash = "sha256-4iGwCGpGwAkriOwQmh5AgvHLX1o39NuQ2l4sAJbD2bc=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    boost
    fcgi
    openssl
    opensaml-cpp
    log4shib
    xercesc
    xml-security-c
    xml-tooling-c
  ];

  configureFlags = [
    "--without-apxs"
    "--with-xmltooling=${xml-tooling-c}"
    "--with-saml=${opensaml-cpp}"
    "--with-fastcgi"
    "CXXFLAGS=-std=c++14"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://shibboleth.net/products/service-provider.html";
    description = "Enables SSO and Federation web applications written with any programming language or framework";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
