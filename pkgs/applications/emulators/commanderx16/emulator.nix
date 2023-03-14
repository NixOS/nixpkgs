{ stdenv
, lib
, fetchFromGitHub
, SDL2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x16-emulator";
  version = "41";

  src = fetchFromGitHub {
    owner = "commanderx16";
    repo = "x16-emulator";
    rev = "r${finalAttrs.version}";
    hash = "sha256-pnWqtSXQzUfQ8ADIXL9r2YjuBwHDQ2NAffAEFCN5Qzw=";
  };

  dontConfigure = true;

  buildInputs = [ SDL2 ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 -t $out/bin/ x16emu
    install -Dm 444 -t $out/share/doc/x16-emulator/ README.md

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.commanderx16.com/forum/index.php?/home/";
    description = "The official emulator of CommanderX16 8-bit computer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    mainProgram = "x16emu";
    inherit (SDL2.meta) platforms;
    broken = with stdenv; isDarwin && isAarch64;
  };

  passthru = {
    # upstream project recommends emulator and rom to be synchronized;
    # passing through the version is useful to ensure this
    inherit (finalAttrs) version;
  };
})
