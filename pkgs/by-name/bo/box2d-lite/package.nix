{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # buildInputs
  libX11,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "box2d-lite";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "erincatto";
    repo = "box2d-lite";
    tag = finalAttrs.version;
    hash = "sha256-XilbE1HsDgpTvmz2EmcF9OZBHkabNxuBAo08al0Zixo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "BOX2D_BUILD_SAMPLES" false)
  ];

  buildInputs = [
    libX11
    libXcursor
    libXi
    libXinerama
    libXrandr
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "''${!outputLib}"/lib
    install -Dm0644 src/*{.a,.so} "''${!outputLib}"/lib

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Small 2D physics engine";
    homepage = "https://github.com/erincatto/box2d-lite";
    changelog = "https://github.com/erincatto/box2d-lite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
  };
})
