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
    version = "1.7-unstable-2025-04-29";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "486b3cf1f685502af7dc87b0f9c9cead6800d47b";
      hash = "sha256-VFBkOWHGZP7GjekHL3GY3BGkVXQbtyD1YPmu0xaQ1ME=";
    };

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
