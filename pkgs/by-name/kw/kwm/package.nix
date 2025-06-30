{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "kwm";
  version = "4.0.5";

  src = fetchzip {
    stripRoot = false;
    url = "https://github.com/koekeishiya/kwm/releases/download/v${version}/Kwm-${version}.zip";
    sha256 = "1ld1vblg3hmc6lpb8p2ljvisbkijjkijf4y87z5y1ia4k8pk7mxb";
  };

  # TODO: Build this properly once we have swiftc.
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp kwmc $out/bin/kwmc
    cp kwm overlaylib.dylib $out

    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.kwm.plist} $out/Library/LaunchDaemons/org.nixos.kwm.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.kwm.plist --subst-var out
  '';

  meta = with lib; {
    description = "Tiling window manager with focus follows mouse for OSX";
    homepage = "https://github.com/koekeishiya/kwm";
    downloadPage = "https://github.com/koekeishiya/kwm/releases";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lnl7 ];
    mainProgram = "kwmc";
    license = licenses.mit;
  };
}
