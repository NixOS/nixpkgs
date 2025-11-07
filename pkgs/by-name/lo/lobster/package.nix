{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  callPackage,

  # Linux deps
  libGL,
  xorg,

}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lobster";
  version = "2025.3";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "lobster";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YGtjoRBGOqkcHaiZNPVFOoeLitJTG/M0I08EPZVCfj0=";
  };

  patches = [
    (fetchpatch {
      name = "cmake-fix.patch";
      url = "https://github.com/aardappel/lobster/commit/a5f46ed65cad43ea70c8a6af5ea2fd5a018c8941.patch?full_index=1";
      hash = "sha256-91pmoTPLD2Fo2SuCKngdRxXFUty5lOyA4oX8zaJ0ON0=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    xorg.libX11
    xorg.libXext
  ];

  preConfigure = ''
    cd dev
  '';

  passthru.tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix { };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://strlen.com/lobster/";
    description = "Lobster programming language";
    mainProgram = "lobster";
    longDescription = ''
      Lobster is a programming language that tries to combine the advantages of
      very static typing and memory management with a very lightweight,
      friendly and terse syntax, by doing most of the heavy lifting for you.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})
