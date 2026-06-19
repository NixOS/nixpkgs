{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_15,
}:

let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "minizign";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "zig-minisign";
    tag = finalAttrs.version;
    hash = "sha256-b32qMmXlsgP3UsDefYo0H1YIKa8B2XiNJP3qbfEuxkA=";
  };

  nativeBuildInputs = [
    zig
  ];

  meta = {
    description = "Minisign reimplemented in Zig";
    homepage = "https://github.com/jedisct1/zig-minisign";
    license = lib.licenses.isc;
    maintainers = [ ];
    mainProgram = "minizign";
    inherit (zig.meta) platforms;
  };
})
