{
  lib,
  stdenv,
  fetchgit,
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
}:

stdenv.mkDerivation rec {
  pname = "shibboleth-sp";
  version = "3.0.4.1";

  src = fetchgit {
    url = "https://git.shibboleth.net/git/cpp-sp.git";
    rev = version;
    sha256 = "1qb4dbz5gk10b9w1rf6f4vv7c2wb3a8bfzif6yiaq96ilqad7gdr";
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
      url = "https://git.shibboleth.net/view/?p=cpp-sp.git;a=blobdiff_plain;f=shibsp/util/IPRange.cpp;h=532cf9e94c915667c091d127c696979f63939eb5;hp=d6f00bc36ea25997817a2308314bcdbea572936f;hb=49cd05fa6d9935a45069fa555db7a26ca77d23db;hpb=293ff2ab6454b0946b3b03719efa132bff461f1f";
      hash = "sha256-ZF0jsZJoHaxaPPjVbT6Wlq+wjyPQLTnEKcUxONji/hE=";
    })

    (fetchpatch {
      name = "char-traits-ambig-2";
      url = "https://git.shibboleth.net/view/?p=cpp-sp.git;a=blobdiff_plain;f=shibsp/util/IPRange.cpp;h=da954870eb03c7cd054ecc5c52a6c1f011787760;hp=354010d5f5e533262cb385ea16756df53fe0c241;hb=793663a67aaa4e9a4aa9172728d924f8cec45cf6;hpb=a43814935030930c49b7a08f5515b861906525c7";
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

  meta = with lib; {
    homepage = "https://shibboleth.net/products/service-provider.html";
    description = "Enables SSO and Federation web applications written with any programming language or framework";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = [ ];
  };
}
