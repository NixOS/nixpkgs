{ lib
, stdenv
, fetchFromGitHub
, zig_0_9
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "colorstorm";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "benbusby";
    repo = "colorstorm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6+P+QQpP1jxsydqhVrZkjl1gaqNcx4kS2994hOBhtu8=";
  };

  nativeBuildInputs = [
    zig_0_9.hook
  ];

  meta = {
    description = "Color theme generator for editors and terminal emulators";
    homepage = "https://github.com/benbusby/colorstorm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    inherit (zig_0_9.meta) platforms;
    mainProgram = "colorstorm";
  };
})
