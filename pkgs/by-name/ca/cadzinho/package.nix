{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_net,
  glew,
  lua5_4,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation rec {
  pname = "cadzinho";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "zecruel";
    repo = "CadZinho";
    tag = version;
    hash = "sha256-AHojy6lYLEyeBaYiIzo6MdQCM3jX5ENNTKgU+PGSD00=";
  };

  postPatch = ''
    substituteInPlace src/gui_config.c --replace-fail "/usr/share/cadzinho" "$out/share/cadzinho"
    substituteInPlace Makefile --replace-fail "-lGLEW" "-lGLEW -lSDL2_net"
  '';

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    SDL2
    SDL2_net
    glew
    lua5_4
  ];

  makeFlags = [ "CC:=$(CC)" ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-I${lib.getInclude SDL2}/include/SDL2"
      "-I${SDL2_net.dev}/include/SDL2"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # https://github.com/llvm/llvm-project/issues/62254
      "-fno-builtin-strrchr"
    ]
  );

  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 cadzinho -t $out/bin
    install -Dm644 lang/*.lua -t $out/share/cadzinho/lang
    cp -r linux/CadZinho/share/* $out/share
    runHook postInstall
  '';

  meta = with lib; {
    description = "Minimalist computer aided design (CAD) software";
    homepage = "https://github.com/zecruel/CadZinho";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
    mainProgram = "cadzinho";
  };
}
