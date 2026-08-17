{
  lib,
  fetchFromGitHub,
  melpaBuild,
  nix-update-script,
  stdenv,
  zig_0_15,
  emacs,
  xcbuild,
}:

let
  zig = zig_0_15;

  pname = "ghostel";

  version = "0.41.0-unstable-2026-07-06";

  src = fetchFromGitHub {
    owner = "dakra";
    repo = "ghostel";
    rev = "eb806d158df4ff302aee68e91caf257f11d66320";
    hash = "sha256-Xz3Sy0iR/g5SoEzqJTZo2ymfMPYQ0NvnAOEoXiXhQFE=";
  };

  module = stdenv.mkDerivation (finalAttrs: {
    inherit pname version src;

    deps = zig.fetchDeps {
      inherit (finalAttrs) src pname version;
      fetchAll = true;
      hash = "sha256-lFU0ywNyP1q2NL9MkIfWciH03VAA/Act5dGYAV4V7EY=";
    };

    nativeBuildInputs = [ zig ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

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
    (:defaults "etc" "ghostel-module${libExt}" "ghostel-module.version")
  '';

  preBuild = ''
    install ${module}/ghostel-module${libExt} ghostel-module${libExt}
    install --mode=444 ${module}/ghostel-module.version ghostel-module.version
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

    inherit module;
  };

  meta = {
    homepage = "https://github.com/dakra/ghostel";
    description = "Terminal emulator powered by libghostty";
    maintainers = with lib.maintainers; [
      rohan-datar
      vonfry
    ];
    license = lib.licenses.gpl3Plus;
  };
}
