{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_15,
  nix-update-script,
}:
let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flow-control";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "neurocyte";
    repo = "flow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5+F0DKb4LXtcMXNutUSJuIe7cdBoFUoJhCs8vbm20jg=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-+07sJAnfB+mKziC5j8QfbL/YzjvRLxqRvpuxGKK7/nA=";
  };

  nativeBuildInputs = [ zig ];

  passthru.updateScript = nix-update-script { };

  dontSetZigDefaultFlags = true;
  zigBuildFlags = [
    "--system"
    "${finalAttrs.zigDeps}"
    "-Dcpu=baseline"
    "-Doptimize=ReleaseFast"
  ];

  env.VERSION = finalAttrs.version;

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Programmer's text editor";
    homepage = "https://github.com/neurocyte/flow";
    changelog = "https://github.com/neurocyte/flow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "flow";
  };
})
