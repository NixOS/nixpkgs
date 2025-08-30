{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_14,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flow-control";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "neurocyte";
    repo = "flow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jt7KJEg5300IuO7m7FiC8zejmymqMqdT7FtoVhTR05M=";
  };

  nativeBuildInputs = [
    zig_0_14.hook
  ];

  zigDeps = zig_0_14.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-jVJdvqQO8svMi170WdJ6oh9UUU2YpwOeLp8FOgg/z+Q=";
  };

  passthru.updateScript = nix-update-script { };

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
