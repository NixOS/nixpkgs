{
  lib,
  fetchFromGitHub,
  direwolf,
  nix-update-script,
  hamlibSupport ? true,
  gpsdSupport ? true,
  extraScripts ? false,
}:

(direwolf.override {
  inherit hamlibSupport gpsdSupport extraScripts;
}).overrideAttrs
  (oldAttrs: {
<<<<<<< HEAD
    version = "1.8.1-unstable-2025-12-28";
=======
    version = "1.8.1-unstable-2025-11-16";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
<<<<<<< HEAD
      rev = "01c31145716fd57e2e53844718bdc769dcce16dd";
      hash = "sha256-OxNhSrxshbdCCNkwnYzz/1NNYwNJYAQiQ7iaXw3x7kc=";
=======
      rev = "694c95485b21c1c22bc4682703771dec4d7a374b";
      hash = "sha256-O2ycOQx4EVwdYGC9LTBlxheMFZp0ddHquSUwVsB5fco=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

    # drop upstreamed cmake-4 patch
    patches = [ ];

    postPatch =
      builtins.replaceStrings
        [
          "decode_aprs.c"
          "tocalls.txt"
          "--replace-fail /etc/udev/rules.d/"
        ]
        [
          "deviceid.c"
          "tocalls.yaml"
          "--replace-fail /usr/lib/udev/rules.d/ $out/lib/udev/rules.d/ --replace-fail /etc/udev/rules.d/"
        ]
        oldAttrs.postPatch;

    dontVersionCheck = true;

    passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  })
