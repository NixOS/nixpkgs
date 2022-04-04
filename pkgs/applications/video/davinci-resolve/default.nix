{ lib, callPackage, fetchpatch, fetchurl, stdenv, pkgsi686Linux }:

let
  generic = args:
    let
      imported = import ./generic.nix args;
    in
    callPackage imported { };
in
rec {

  stable = generic {
    version = "17.4.6";
    pname = "davinci-resolve";
    downloadid = "0e34f66357634628b918e96b6680c137";
    referid = "95925530c5fd4572a47debdcdc2e3f23";
    outputHash = "0cxhvn2i6j0ji2wk3qwq3gc70vx3vfvh5hn81l7km9n9kfxbc0nd";
  };

  beta = generic {
    version = "17.0b10";
    pname = "davinci-resolve-beta";
    downloadid = "12e3370b90704a3eb632574b67f51425";
    referid = "73eca88216ee485a86a44dfd53692c55";
    # I cant get past the download error.. still troubleshooting
    outputHash = "0cxhvn2i6j0ji2wk3qwq3gc70vx3vfvh5hn81l7km9n9kfxbc0nd";
  };

  studio = generic {
    version = "17.4.6";
    pname = "davinci-resolve-studio";
    downloadid = "34023b93d9f64d03aaf7654e2cbbb727";
    referid = "acf4e4c3c28040cca505e69a365d42a0";
    outputHash = "17rayma68r4niympk6xp2n06n5gq76vmr5id278wi1cm7pc3fm47";
  };

}
