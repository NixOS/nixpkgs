{
  stdenv,
  lib,
  fetchFromGitea,
  linux-pam,
  libxcb,
  makeBinaryWrapper,
  zig_0_14,
  callPackage,
  nixosTests,
  x11Support ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ly";
  version = "1.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "AnErrupTion";
    repo = "ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+rRvrlzV5MDwb/7pr/oZjxxDmE1kbnchyUi70xwp0Cw=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig_0_14.hook
  ];
  buildInputs = [
    linux-pam
  ] ++ (lib.optionals x11Support [ libxcb ]);

  postPatch = ''
    ln -s ${
      callPackage ./deps.nix {
        zig = zig_0_14;
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';
  zigBuildFlags = [
    "-Denable_x11_support=${lib.boolToString x11Support}"
  ];

  passthru.tests = { inherit (nixosTests) ly; };

  meta = {
    description = "TUI display manager";
    license = lib.licenses.wtfpl;
    homepage = "https://codeberg.org/AnErrupTion/ly";
    maintainers = [ lib.maintainers.vidister ];
    platforms = lib.platforms.linux;
    mainProgram = "ly";
  };
})
