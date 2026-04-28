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

  version = "0.18.1-unstable-2026-04-28";

  src = fetchFromGitHub {
    owner = "dakra";
    repo = "ghostel";
    rev = "90f1f71d022910a5f86da1d413ea155422eac5dc";
    hash = "sha256-653lCO6RQW1wgFJE6/J0f2I4xTBZ7QnqwEmB02REJdY=";
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
