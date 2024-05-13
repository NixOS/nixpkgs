{ lib
, pkgs
, fetchFromGitHub
, zig_0_12
, darwin
}:

let stdenv = if pkgs.stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else pkgs.stdenv; in

stdenv.mkDerivation (finalAttrs: {
  pname = "glsl_analyzer";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "nolanderc";
    repo = "glsl_analyzer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+eYBw/F1RzI5waAkLgbV0J/Td91hbNcAtHcisQaL82k=";
  };

  nativeBuildInputs = [
    zig_0_12.hook
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
