{ lib
, stdenv
, fetchFromGitHub
, zig_0_13
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glsl_analyzer";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "nolanderc";
    repo = "glsl_analyzer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AIzk05T8JZn8HWSI6JDFUIYl4sutd3HR3Zb+xmJll0g=";
  };

  nativeBuildInputs = [
    zig_0_13.hook
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
