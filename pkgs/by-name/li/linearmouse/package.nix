{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "linearmouse";
  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/linearmouse/linearmouse/releases/download/v${version}/LinearMouse.dmg";
    hash = "sha256-Ic0dEQEN1e78H/M2jOg2bEEU+ZtZ6nN6ykMJ+db7afE=";
  };

  sourceRoot = ".";

  unpackCmd = ''
    mnt=$(TMPDIR=/tmp mktemp -d -t nix-XXXXXXXXXX)

    function finish {
      /usr/bin/hdiutil detach $mnt -force
      rm -rf $mnt
    }
    trap finish EXIT

    /usr/bin/hdiutil attach -nobrowse -mountpoint $mnt $src
    cp -a $mnt/LinearMouse.app $PWD/
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    mv LinearMouse.app $out/Applications/
    runHook postInstall
  '';

  meta = with lib; {
    description = "The mouse and trackpad utility for Mac";
    homepage = "https://github.com/linearmouse/linearmouse";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.darwin;
    maintainers = with maintainers; [ ilaumjd ];
    license = licenses.mit;
  };
}
