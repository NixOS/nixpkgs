{ stdenv
, lib
, fetchFromGitHub
, cc65
, python3
}:

stdenv.mkDerivation rec {
  pname = "x16-rom";
  version = "40";

  src = fetchFromGitHub {
    owner = "commanderx16";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-5oqttuTJiJOUENncOJipAar22OsI1uG3G69m+eYoSh0=";
  };

  nativeBuildInputs = [
    cc65
    python3
  ];

  postPatch = ''
    patchShebangs scripts/
  '';

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install -Dm 444 -t $out/share/${pname} build/x16/rom.bin
    install -Dm 444 -t $out/share/doc/${pname} README.md

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.commanderx16.com/forum/index.php?/home/";
    description = "ROM file for CommanderX16 8-bit computer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (cc65.meta) platforms;
  };

  passthru = {
    # upstream project recommends emulator and rom synchronized;
    # passing through the version is useful to ensure this
    inherit version;
  };
}
