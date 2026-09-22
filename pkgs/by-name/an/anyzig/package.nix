{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  zig_0_14,
  nix-update-script,
}:

let
  zig = zig_0_14;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "anyzig";
  version = "2026_03_26";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "marler8997";
    repo = "anyzig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MQWFKVXsJdv/kV9Kn0GexiSLNDJdd9IGN9rQa2lhF6k=";
  };

  postPatch = ''
    substituteInPlace build.zig.zon --replace-fail \
      '12201a08d7eff7619c8eb8284691a3ff959861b4bdd87216f180ed136672fb4ea26f' \
      'zipcmdline-0.0.0-AAAAAKBaAAAaCNfv92GcjrgoRpGj_5WYYbS92HIW8YDt'
  '';

  nativeBuildInputs = [ zig ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-BeCa4IrFbb/bsz+ZuhKRUb9wV8a+JV/11FOBt8JJOKA=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Universal zig executable that lets you run any version of zig";
    homepage = "https://github.com/marler8997/anyzig";
    changelog = "https://github.com/marler8997/anyzig/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "zig";
  };
})
