{ lib, stdenv, fetchFromGitHub, SDL2, glew, lua5_4, desktopToDarwinBundle }:

stdenv.mkDerivation rec {
  pname = "cadzinho";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "zecruel";
    repo = "CadZinho";
    rev = version;
    hash = "sha256-6/sBNxQb52FFO2fWLVs6YDOmJLEbSOA5mwdMdJDjEDM=";
  };

  postPatch = ''
    substituteInPlace src/gui_config.c --replace "/usr/share/cadzinho" "$out/share/cadzinho"
  '';

  nativeBuildInputs = lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [ SDL2 glew lua5_4 ];

  makeFlags = [ "CC:=$(CC)" ];

  # https://github.com/llvm/llvm-project/issues/62254
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-fno-builtin-strrchr";

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
