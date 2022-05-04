{ stdenv
, lib
, fetchFromGitHub
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "x16-emulator";
  version = "40";

  src = fetchFromGitHub {
    owner = "commanderx16";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-7ZzVd2NJCFNAFrS2cj6bxcq/AzO5VakoFX9o1Ac9egg=";
  };

  dontConfigure = true;

  buildInputs = [ SDL2 ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 -t $out/bin/ x16emu
    install -Dm 444 -t $out/share/doc/${pname} README.md

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.commanderx16.com/forum/index.php?/home/";
    description = "The official emulator of CommanderX16 8-bit computer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (SDL2.meta) platforms;
  };

  passthru = {
    # upstream project recommends emulator and rom synchronized;
    # passing through the version is useful to ensure this
    inherit version;
  };
}
