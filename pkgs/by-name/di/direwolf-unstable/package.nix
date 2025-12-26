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
    version = "1.8.1-unstable-2025-12-19";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "1924999dbd24ce155aff69fec76cee35ad478bdd";
      hash = "sha256-Q9mYeDQHaMNez1oQHaQTfjU/AxAKhpB98UcmaNujMjA=";
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
