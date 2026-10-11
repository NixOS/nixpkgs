{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  freeglut,
  glew,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cal3d";
  version = "0.120"; # actually 0.12.0

  src = fetchFromGitHub {
    owner = "mp3butcher";
    repo = "Cal3D";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-974pqfgLBmEEC3/jNwP+fa4ENDTEBkqbffnbKrBcBfc=";
  };

  sourceRoot = "${finalAttrs.src.name}/cal3d";

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # return `0` instead of `false` in some places
    ./fix-boolean-ptr-conversion.patch

    # std::auto_ptr was removed in favour of std::unique_ptr
    ./remove-auto-ptr.patch
  ];

  postPatch = ''
    sed -i "/AM_USE_UNITTESTCPP/d" configure.in
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    freeglut
    glew
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=narrowing"
    ]
  );

  meta = {
    changelog = "https://github.com/mp3butcher/Cal3D/blob/${finalAttrs.src.rev}/cal3d/ChangeLog";
    description = "3D character animation library";
    homepage = "https://mp3butcher.github.io/Cal3D";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
