{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kmodigest";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "emilazy";
    repo = "boot-security-tools";
    tag = "kmodigest/v${finalAttrs.version}";
    hash = "sha256-DXgDf6GHEz6N3YWwsBIQOZm7m5OCoJMeK+357zcU5tc=";
  };

  cargoHash = "sha256-tTsPubllIqtCoVGk81ZK34NkuqElm6OQjwWp4xdt/Ek=";

  buildAndTestSubdir = "kmodigest";

  useNextest = true;

  cargoTestFlags = [ "--max-fail=all" ];

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    description = "Tool to produce deterministic Linux kernel module signatures and certificates";
    homepage = "https://github.com/emilazy/boot-security-tools/tree/main/kmodigest";
    license = lib.licenses.blueOak100;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    teams = [ lib.teams.boot-security ];
    mainProgram = "kmodigest";
  };
})
