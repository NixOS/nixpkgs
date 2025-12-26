{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  zlib,
  bash,
  buildPackages,
  nix-update-script,
  pkgsCross,
  pkgsStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cracklib";
  version = "2.10.3";

  src = fetchFromGitHub {
    owner = "cracklib";
    repo = "cracklib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ORpJje4TGw1STtvRiNEwUwSDbLXdS+WgXGlc1Wtf/gw=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ buildPackages.cracklib ];

  buildInputs = [
    zlib
    bash
  ];

  configureFlags = [
    "--without-python"
  ];

  postInstall =
    # For cross compilation use the tools from nativeBuildInputs. Otherwise use
    # the ones in the util directory of the source tree.
    lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
      PATH=$PATH:util
    ''
    + ''
      cracklib-format $out/share/cracklib/cracklib-small \
      | cracklib-packer $out/share/cracklib/pw_dict
    '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      cross =
        let
          systemString = if stdenv.buildPlatform.isAarch64 then "gnu64" else "aarch64-multiplatform";
        in
        pkgsCross.${systemString}.cracklib;
      static = pkgsStatic.cracklib;
    };
  };

  meta = {
    homepage = "https://github.com/cracklib/cracklib";
    description = "Password checking library";
    changelog = "https://github.com/cracklib/cracklib/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;
  };
})
