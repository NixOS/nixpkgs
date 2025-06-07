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
}:

stdenv.mkDerivation {
  pname = "ly";
  version = "1.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "AnErrupTion";
    repo = "ly";
    rev = "v1.1.0";
    hash = "sha256-+rRvrlzV5MDwb/7pr/oZjxxDmE1kbnchyUi70xwp0Cw=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    zig_0_14.hook
  ];
  buildInputs = [
    libxcb
    linux-pam
  ];

  postPatch = ''
    ln -s ${
      callPackage ./deps.nix {
        zig = zig_0_14;
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';

  passthru.tests = { inherit (nixosTests) ly; };

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://codeberg.org/AnErrupTion/ly";
    maintainers = [ maintainers.vidister ];
    platforms = platforms.linux;
    mainProgram = "ly";
  };
}
