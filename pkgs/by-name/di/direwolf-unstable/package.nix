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
    version = "1.8.1-unstable-2026-01-03";

    src = fetchFromGitHub {
      owner = "wb2osz";
      repo = "direwolf";
      rev = "9aba4b386f841e5c9c9068a2259f7f5058a5dee5";
      hash = "sha256-MHzPwx4N+LLETEZMQz4hmM+1qbwNJjHSISvTWROg+3o=";
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
