{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  zig_0_16,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fx-sh";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "fx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NeDAx55Ws3pZJeug8rYEFQaMI2Kf1Smz07nwhhiL+WM=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ zig.hook ];

  zigBuildFlags = [ "-Doptimize=ReleaseSafe" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unix like coding agent";
    homepage = "https://github.com/vercel-labs/fx";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      abhi-kr-2100
      amadejkastelic
    ];
    mainProgram = "fx";
    platforms = lib.platforms.all;
  };
})
