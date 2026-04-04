{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  pipewire,
}:
stdenv.mkDerivation rec {
  pname = "audio-share";
  version = "0.3.4";

  src = fetchurl {
    url = "https://github.com/mkckr0/audio-share/releases/download/v${version}/audio-share-server-cmd-linux.tar.gz";
    hash = "sha256-3PJculwZ8L7YwS7Hw3RSHlx9mL5Q0M6YhiUWELtDUk8=";
  };

  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [pipewire stdenv.cc.cc.lib];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp bin/as-cmd $out/bin/as-cmd
    chmod +x $out/bin/as-cmd
  '';

  meta = with lib; {
    description = "Share Linux audio to an Android phone over the network";
    homepage = "https://github.com/mkckr0/audio-share";
    license = licenses.asl20;
    maintainers = with maintainers; [wetrustinprize];
    platforms = ["x86_64-linux"];
    mainProgram = "as-cmd";
  };
}
