{
  fetchFromCodeberg,
  llvmPackages_21,
  zig,
}:

# This is kinda atrocious, but it works
let
  zigOverride =
    (zig.override {
      llvmPackages = llvmPackages_21;
    }).overrideAttrs
      (oldAttrs: {
        version = "0.16.0";
        src = fetchFromCodeberg {
          owner = "ziglang";
          repo = "zig";
          rev = "d3e20e71be8d94b8c0534d2cb57a1a27c451db9f"; # Specific commit the game is built with, needed since cubyz is incompatible with stable versions of zig
          hash = "sha256-DKOQiB183AuWhkitPclFJqKBi9CTkK6Lccw1vLgF0OQ=";
        };

        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [
          llvmPackages_21.llvm
          llvmPackages_21.lld
          llvmPackages_21.clang
        ];
      });
in

zigOverride.hook.overrideAttrs {
  zig_default_flags = "";
}
