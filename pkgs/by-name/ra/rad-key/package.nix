{
  lib,
  stdenvNoCC,
  fetchFromRadicle,
  zig_0_17,
  versionCheckHook,
}:

let
  zig = zig_0_17;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rad-key";
  version = "0.2.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromRadicle {
    seed = "radicle.defelo.de";
    repo = "zFF3JpT1VrrsDYogDPtVZMHw6P4x";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-tHMq0nToYLg9YbcF8p5MTTTNaJK3GWuuA+bTd3qJHoU=";
  };

  nativeBuildInputs = [ zig ];

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Convert between Radicle identities and public SSH keys";
    homepage = "https://radicle.defelo.de/nodes/radicle.defelo.de/rad:zFF3JpT1VrrsDYogDPtVZMHw6P4x";
    changelog = "https://radicle.defelo.de/nodes/radicle.defelo.de/rad:zFF3JpT1VrrsDYogDPtVZMHw6P4x/tree/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.radicle ];
    mainProgram = "rad-key";
  };
})
