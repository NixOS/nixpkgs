{ stdenv
, lib
, fetchFromGitHub
, cc65
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x16-rom";
  version = "41";

  src = fetchFromGitHub {
    owner = "commanderx16";
    repo = "x16-rom";
    rev = "r${finalAttrs.version}";
    hash = "sha256-kowdyUVi3hliqkL8VQo5dS3Dpxd4LQi5+5brkdnv0lE=";
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

    install -Dm 444 -t $out/share/x16-rom/ build/x16/rom.bin
    install -Dm 444 -t $out/share/doc/x16-rom/ README.md

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.commanderx16.com/forum/index.php?/home/";
    description = "ROM file for CommanderX16 8-bit computer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (cc65.meta) platforms;
    broken = with stdenv; isDarwin && isAarch64;
  };

  passthru = {
    # upstream project recommends emulator and rom to be synchronized;
    # passing through the version is useful to ensure this
    inherit (finalAttrs) version;
  };
})
