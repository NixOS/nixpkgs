{ lib
, stdenv
, zstd
, fetchurl
, openjdk
, libnotify
, makeWrapper
, bash
}:
let

in
stdenv.mkDerivation rec {
  pname = "briar-desktop";
  version = "0.5.0-beta";

  src = fetchurl {
    url = "https://desktop.briarproject.org/jars/linux/${version}/briar-desktop-linux-${version}.jar";
    hash = "sha256-J93ODYAiRbQxG2BF7P3H792ymAcJ3f07l7zRSw8kM+E=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp ${src} $out/lib/briar-desktop.jar
    makeWrapper ${openjdk}/bin/java $out/bin/briar-desktop \
      --add-flags "-jar $out/lib/briar-desktop.jar" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        libnotify
      ]}"
  '';

  meta = with lib; {
    description = "Decentalized and secure messnger";
    homepage = "https://code.briarproject.org/briar/briar-desktop";
    license = licenses.gpl3;
    maintainers = with maintainers; [ onny ];
    platforms = [ "x86_64-linux" ];
  };
}
