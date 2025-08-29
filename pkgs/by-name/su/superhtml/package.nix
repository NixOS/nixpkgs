{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_13,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "superhtml";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "superhtml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rO7HS07nSqwOq6345q/SOL2imoD0cKV16QJcVVr6mHw=";
  };

  zigDeps = zig_0_13.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ZkXhfamOlPzW3outAZy8h2PVS/z5AfcfF4jj1MDmtZA=";
  };

  nativeBuildInputs = [
    zig_0_13.hook
  ];

  meta = with lib; {
    description = "HTML Language Server and Templating Language Library";
    homepage = "https://github.com/kristoff-it/superhtml";
    license = licenses.mit;
    mainProgram = "superhtml";
    maintainers = with maintainers; [ petertriho ];
    platforms = platforms.unix;
  };
})
