{
  lib,
  stdenv,
  fetchurl,
  alglib,
  unzip,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "rainbowcrack";
  version = "1.8";

  src = fetchurl {
    url = "http://project-rainbowcrack.com/rainbowcrack-${version}-linux64.zip";
    hash = "sha256-xMC9teHiDvBY/VHV63TsNQjdcuLqHGeXUyjHvRTO9HQ=";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  dontConfigure = true;

  dontBuild = true;

  unpackPhase = ''
    mkdir -p $out/{bin,share/rainbowcrack}
    unzip $src -d $out || true
  '';

  installPhase = ''
    install -Dm644 $out/rainbowcrack-1.8-linux64/*.txt $out/share/rainbowcrack
    install -Dm755 $out/rainbowcrack-1.8-linux64/rt* $out/rainbowcrack-1.8-linux64/rcrack $out/bin
    chmod +x $out/bin/*
    rm -rf $out/rainbowcrack-1.8-linux64
  '';

  runtimeDependencies = [ alglib ];

  meta = {
    description = "Rainbow table generator used for password cracking";
    homepage = "http://project-rainbowcrack.com";
    maintainers = with lib.maintainers; [ tochiaha ];
    license = lib.licenses.unfree;
    mainProgram = "rcrack";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux64" ];
  };
}
