{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_15,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flow-control";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "neurocyte";
    repo = "flow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5+F0DKb4LXtcMXNutUSJuIe7cdBoFUoJhCs8vbm20jg=";
  };

  nativeBuildInputs = [ zig_0_15 ];

  zigDeps = zig_0_15.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+07sJAnfB+mKziC5j8QfbL/YzjvRLxqRvpuxGKK7/nA=";
  };

  passthru.updateScript = nix-update-script { };

  dontSetZigDefaultFlags = true;
  zigBuildFlags = [
    "-Dcpu=baseline"
    "-Doptimize=ReleaseFast"
  ];

  env.VERSION = finalAttrs.version;

  meta = {
    description = "Programmer's text editor";
    homepage = "https://github.com/neurocyte/flow";
    changelog = "https://github.com/neurocyte/flow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "flow";
  };
})
