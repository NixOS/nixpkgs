{
  stdenv,
  lib,
  fetchFromGitea,
  linux-pam,
  libxcb,
  makeBinaryWrapper,
  zig_0_13,
  callPackage,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ly";
  version = "1.0.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "AnErrupTion";
    repo = "ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TsEn0kH7j4myjjgwHnbOUmIZjHn8A1d/7IjamoWxpXQ=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig_0_13.hook
  ];
  buildInputs = [
    libxcb
    linux-pam
  ];

  postPatch = ''
    ln -s ${
      callPackage ./deps.nix {
        zig = zig_0_13;
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';

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
