{
  lib,
  fetchFromGitHub,
  melpaBuild,
  nix-update-script,
  stdenv,
  zig_0_15,
  emacs,
}:

let
  zig = zig_0_15;

  pname = "ghostel";

  version = "0.31.0-unstable-2026-06-01";

  src = fetchFromGitHub {
    owner = "dakra";
    repo = "ghostel";
    rev = "09aad9fefffce6370256a9888a1ed4f77535fcfd";
    hash = "sha256-CKN0m+DVvxJhLkr/Hi/44w0m+kJVrx28axLCKLogIQs=";
  };

  module = stdenv.mkDerivation (finalAttrs: {
    inherit pname version src;

    deps = zig.fetchDeps {
      inherit (finalAttrs) src pname version;
      fetchAll = true;
      hash = "sha256-ghN/UMACgkFQQEr4nH5gbbJbt/+2bz6tL2bJpbw9mGE=";
    };

    nativeBuildInputs = [ zig ];

    env.EMACS_INCLUDE_DIR = "${emacs}/include";

    dontSetZigDefaultFlags = true;

    doCheck = true;

    zigCheckFlags = [
      "-Dcpu=baseline"
      # See https://github.com/ghostty-org/ghostty/blob/main/PACKAGING.md#build-options
      "-Doptimize=ReleaseFast"
    ];

    zigBuildFlags = finalAttrs.zigCheckFlags;

    postConfigure = ''
      cp -rLT ${finalAttrs.deps} "$ZIG_GLOBAL_CACHE_DIR/p"
      chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
    '';
  });

  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
melpaBuild {
  inherit pname version src;

  files = ''
    (:defaults "etc" "ghostel-module${libExt}")
  '';

  preBuild = ''
    install ${module}/lib/libghostel-module${libExt} ghostel-module${libExt}
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

    inherit module;
  };

  meta = {
    homepage = "https://github.com/dakra/ghostel";
    description = "Terminal emulator powered by libghostty";
    maintainers = with lib.maintainers; [ vonfry ];
    license = lib.licenses.gpl3Plus;
  };
}
