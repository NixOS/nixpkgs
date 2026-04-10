{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
}:
stdenv.mkDerivation (finalAttrs: {
  # fast-cli existed, was removed as noted in aliasses.nix on 2025-11-17. Consider to rename this package after 1 to 2 releases of nixos
  pname = "fast-cli-zig";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "mikkelam";
    repo = "fast-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KKjxKQHiSYMaGCfX1+h6DQ809xHh9Yfv8B4PXvr3CwQ=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-89ig8lO5Yb9qFlJ1yL3NDDfKeZDl/CeM6qFxT40eOf8=";
  };

  nativeBuildInputs = [ zig.hook ];

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  doCheck = true;
  # Tests create a local http server to check the latency functionality
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command line version of fast.com in ~1.2 MB";
    homepage = "https://github.com/mikkelam/fast-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dwt ];
    mainProgram = "fast-cli";
    inherit (zig.meta) platforms;
  };
})
