{
  lib,
  fetchFromGitLab,
  stdenv,
  zig_0_14,
}:

let
  zig = zig_0_14;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "outfieldr";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "ve-nt";
    repo = "outfieldr";
    rev = finalAttrs.version;
    hash = "sha256-rokGB1be09ExK9VH5tCW8ccZiIMd3A9pbuMFrOouhOc=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  meta = {
    description = "TLDR client written in Zig";
    homepage = "https://gitlab.com/ve-nt/outfieldr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hasnep ];
    mainProgram = "tldr";
    inherit (zig.meta) platforms;
  };
})
