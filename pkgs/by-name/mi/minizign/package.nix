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
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "zig-minisign";
    tag = finalAttrs.version;
    hash = "sha256-W1rfIZqEGaBkLE2Goug4ANBWj6mc4hurVhsJ0NWH4nY=";
  };

  nativeBuildInputs = [
    zig.hook
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
