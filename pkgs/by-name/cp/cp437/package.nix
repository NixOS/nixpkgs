{
  lib,
  stdenv,
  fetchFromGitHub,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cp437";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "keaston";
    repo = "cp437";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jL23/mvdwu2wEXfxeX1AZAg0AeoRrgoXZThub52txKE=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "SYSTEM=${stdenv.hostPlatform.uname.system}"
  ];

  installPhase = ''
    install -Dm755 cp437 -t $out/bin
  '';

  meta = {
    description = ''
      Emulates an old-style "code page 437" / "IBM-PC" character
      set terminal on a modern UTF-8 terminal emulator
    '';
    homepage = "https://github.com/keaston/cp437";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jb55 ];
    mainProgram = "cp437";
    platforms = lib.platforms.unix;
  };
})
