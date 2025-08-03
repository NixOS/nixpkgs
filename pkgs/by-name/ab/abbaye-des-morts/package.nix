{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_image,
  SDL2_mixer,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abbaye-des-morts";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "nevat";
    repo = "abbayedesmorts-gpl";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-muJt1cml0nYdgl0v8cudpUXcdSntc49e6zICTCwzkks=";
  };

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "DESTDIR="
  ]
  ++ lib.optional stdenv.isDarwin "PLATFORM=mac";

  # Even with PLATFORM=mac, the Makefile specifies some GCC-specific CFLAGS that
  # are not supported by modern Clang on macOS
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail "-funswitch-loops" "" \
      --replace-fail "-fgcse-after-reload" ""
  '';

  meta = {
    homepage = "https://locomalito.com/abbaye_des_morts.php";
    description = "Retro arcade video game";
    mainProgram = "abbayev2";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
})
