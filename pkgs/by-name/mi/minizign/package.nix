{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_17,
  versionCheckHook,
}:

let
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "minizign";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "zig-minisign";
    tag = finalAttrs.version;
    hash = "sha256-th5jVLbGDfTJcciNevBZ+/w3Et3OW+puGHu9NexCsQs=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-DxNZw68RIExGcWFmL6Q/ks67dSQQSdKo5P4U9sPZfZg=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    zig
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Minisign reimplemented in Zig";
    homepage = "https://github.com/jedisct1/zig-minisign";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "minizign";
    inherit (zig.meta) platforms;
  };
})
