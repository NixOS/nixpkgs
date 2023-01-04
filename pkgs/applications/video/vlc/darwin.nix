{ version, meta, stdenv, fetchurl, lib, undmg, makeWrapper }:

let
  srcs = {
    aarch64-darwin = fetchurl {
      url =
        "http://get.videolan.org/vlc/${version}/macosx/vlc-${version}-arm64.dmg";
      sha256 = "sha256-mcJZvbxSIf1QgX9Ri3Dpv57hdeiQdDkDyYB7x3hmj0c=";
    };
    x86_64-darwin = fetchurl {
      url =
        "http://get.videolan.org/vlc/${version}/macosx/vlc-${version}-intel64.dmg";
      sha256 = "sha256-iO3N/Os70vaANn2QCdOKDBR/p1jy3TleQ0EsHgjOHMs=";
    };
  };
in stdenv.mkDerivation {
  inherit version meta;

  src = srcs.${stdenv.hostPlatform.system};

  pname = "vlc";

  nativeBuildInputs = [ undmg makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "VLC.app" $out/Applications

    # wrap executable to $out/bin
    mkdir -p $out/bin
    makeWrapper "$out/Applications/VLC.app/Contents/MacOS/VLC" "$out/bin/vlc"

    runHook postInstall
  '';
}
