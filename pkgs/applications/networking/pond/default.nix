{ lib, goPackages, fetchgit, trousers }:

with goPackages;

buildGoPackage rec {
  rev = "f4e441c77a2039814046ff8219629c547fe8b689";
  name = "pond-${lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/agl/pond";
  src = fetchgit {
    inherit rev;
    url = "git://github.com/agl/pond.git";
    sha256 = "f2dfc6cb96cc4b8ae732e41d1958b62036f40cb346df2e14f27b5964a1416026";
  };

  subPackages = [ "client" ];

  buildInputs = [ trousers net crypto protobuf ed25519 ];
    
  buildFlags = "--tags nogui";

  dontInstallSrc = true;

  meta = with lib; {
    description = "Forward secure, asynchronous messaging for the discerning";
    homepage = https://pond.imperialviolet.org;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}

