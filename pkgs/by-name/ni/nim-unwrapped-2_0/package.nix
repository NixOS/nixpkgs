{
  lib,
  fetchurl,
  stdenv,
  nim-unwrapped-2_2,
}:

nim-unwrapped-2_2.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "2.0.16";
    src = fetchurl {
      url = "https://nim-lang.org/download/nim-${finalAttrs.version}.tar.xz";
      hash = "sha256-sucMbAEbVQcJMJCoiH+iUncyCP0EfuOPhWLiVp5cN4o=";
    };
    patches = lib.lists.unique (
      builtins.filter (
        p:
        builtins.elem (baseNameOf p) [
          "NIM_CONFIG_DIR.patch"
          "nixbuild.patch"
          "extra-mangling.patch" # Mangle store paths of modules to prevent runtime dependence.
          "openssl.patch"
        ]
      ) (lib.optional (!stdenv.hostPlatform.isWindows) ./toLocation.patch ++ nim-unwrapped-2_2.patches)
    );
  }
)
