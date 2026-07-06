{
  lib,
  stdenv,
  fetchurl,
  nim-unwrapped-2,
}:

nim-unwrapped-2.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "1.6.20";
    src = fetchurl {
      url = "https://nim-lang.org/download/nim-${finalAttrs.version}.tar.xz";
      hash = "sha256-/+0EdQTR/K9hDw3Xzz4Ce+kaKSsMnFEWFQTC87mE/7k=";
    };

    patches =
      builtins.filter (
        p:
        builtins.elem (baseNameOf p) [
          "NIM_CONFIG_DIR.patch"
          "nixbuild.patch"
        ]
      ) nim-unwrapped-2.patches
      ++ [
        ./extra-mangling.patch
        # Mangle store paths of modules to prevent runtime dependence.
      ]
      ++ lib.optional (!stdenv.hostPlatform.isWindows) ./toLocation.patch;
  }
)
