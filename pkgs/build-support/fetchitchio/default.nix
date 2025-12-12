{
  lib,
  fetchurl,
}:

lib.extendMkDerivation {
  constructDrv = fetchurl;
  excludeDrvArgNames = [
    "apiKey"
    "upload"
    "gameUrl"
    "extraMessage"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      apiKey ? builtins.getEnv "NIXPKGS_ITCHIO_API_KEY",
      upload,
      name ? null,
      gameUrl ? null,
      extraMessage ? null,
      ...
    }:
    {
      url =
        if apiKey == "" then
          throw "Either set NIXPKGS_ITCHIO_API_KEY or manually download ${
            if name == null then "the required file" else name
          } from ${if gameUrl == null then "itch.io" else gameUrl} and add it to Nix store."
          + (if extraMessage != null then " ${extraMessage}" else "")
        else
          "https://api.itch.io/uploads/${upload}/download?api_key=${apiKey}";
    };
}
