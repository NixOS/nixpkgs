{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  zig_0_17,
}:

let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fx-sh";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "fx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zAvoaadFqjLEsXQt9GyU0ziHaW6wMh2JRCR2PSB1AZU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ zig ];

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
