{
  lib,
  fetchurl,
  nim-unwrapped-1,
  nim-unwrapped-2_2,
}:

nim-unwrapped-2_2.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "2.0.12";
    src = fetchurl {
      url = "https://nim-lang.org/download/nim-${finalAttrs.version}.tar.xz";
      hash = "sha256-xIh5ScXrjX+an1bwrrK/IUD6vwruDwWAoxnioJgVczo=";
    };
    patches = lib.lists.unique (
      builtins.filter (
        p:
        builtins.elem (builtins.baseNameOf p) [
          "NIM_CONFIG_DIR.patch"
          "nixbuild.patch"
          "extra-mangling.patch"
          "openssl.patch"
        ]
      ) (nim-unwrapped-1.patches ++ nim-unwrapped-2_2.patches)
    );
  }
)
