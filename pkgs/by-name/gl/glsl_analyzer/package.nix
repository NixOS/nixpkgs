{
  lib,
  stdenv,
  fetchFromGitHub,
  zig_0_14,
}:
let
  zig = zig_0_14;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "glsl_analyzer";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "nolanderc";
    repo = "glsl_analyzer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-429S4iTkXQ64Fd153Xr7Z7eKbqKe0gI9yAvMPNV2/dE=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  postPatch = ''
    substituteInPlace build.zig \
      --replace-fail 'b.run(&.{ "git", "describe", "--tags", "--always" })' '"${finalAttrs.src.rev}"'
  '';

  meta = {
    description = "Language server for GLSL (OpenGL Shading Language)";
    changelog = "https://github.com/nolanderc/glsl_analyzer/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/nolanderc/glsl_analyzer";
    mainProgram = "glsl_analyzer";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ wr7 ];
    platforms = lib.platforms.unix;
  };
})
