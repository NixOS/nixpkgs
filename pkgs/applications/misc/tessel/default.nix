{ stdenv, fetchurl, callPackage, libusb1, pkgconfig, python, utillinux }:

with stdenv.lib;

let 
  nodePackages = callPackage (import ../../../top-level/node-packages.nix) {
    neededNatives =  [ libusb1 pkgconfig python utillinux ];
    self = nodePackages;
    generated = ./package.nix;
  };

in nodePackages.buildNodePackage rec {
  name = "tessel-0.3.16";
  bin = true;
  
  src = [
    (fetchurl {
      url = "http://registry.npmjs.org/tessel/-/tessel-0.3.16.tgz";
      name = "tessel-0.3.16.tgz";
      sha1 = "900a8d897ba03d7a9d5927697180284772d70738";
    })
  ];

  deps = (filter (v: nixType v == "derivation") (attrValues nodePackages));

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp $out/lib/node_modules/tessel/install/85-tessel.rules $out/etc/udev/rules.d/
  '';
  
  passthru.names = [ "tessel" ];

  meta = {
    description = "Command line tools and programmatic access library for Tessel devices";
    homepage = https://tessel.io;
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
    platforms = with platforms; linux;
  };
}
