{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, freeglut
, glew
, unittest-cpp
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cal3d";
  version = "0.120"; # actually 0.12.0

  src = fetchFromGitHub {
    owner = "mp3butcher";
    repo = "Cal3D";
    rev = finalAttrs.version;
    hash = "sha256-974pqfgLBmEEC3/jNwP+fa4ENDTEBkqbffnbKrBcBfc=";
  };

  sourceRoot = "${finalAttrs.src.name}/cal3d";

  outputs = [ "out" "dev" ];

  patches = [
    ./fix-boolean-ptr-conversion.patch
  ];

  postPatch = ''
    sed -i "/AM_USE_UNITTESTCPP/d" configure.in
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ freeglut glew ];

  meta = {
    changelog = "https://github.com/mp3butcher/Cal3D/blob/${finalAttrs.src.rev}/cal3d/ChangeLog";
    description = "3D character animation library";
    homepage = "https://mp3butcher.github.io/Cal3D";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})


