{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_13,
  apple-sdk_11,
}:

let
  zig = zig_0_13;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "minizign";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "zig-minisign";
    rev = finalAttrs.version;
    hash = "sha256-Su66UohRc9C4INIp+7NHiW28sUq5YBfrI0EoEbGojG0=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  meta = {
    description = "Minisign reimplemented in Zig";
    homepage = "https://github.com/jedisct1/zig-minisign";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "minizign";
    inherit (zig.meta) platforms;
  };
})
