{ lib
, stdenv
, fetchzip
, openjdk
, makeWrapper
, tor
, p7zip
, bash
, writeScript
}:
let

  briar-tor = writeScript "briar-tor" ''
    #! ${bash}/bin/bash
    exec ${tor}/bin/tor "$@"
  '';

in
stdenv.mkDerivation rec {
  pname = "briar-desktop";
  version = "0.2.1-beta";

  src = fetchzip {
    url = "https://code.briarproject.org/briar/briar-desktop/-/jobs/18424/artifacts/download?file_type=archive";
    sha256 = "sha256-ivMbgo0+iZE4/Iffq9HUBErGIQMVLrRZUQ6R3V3X8II=";
    extension = "zip";
  };

  nativeBuildInputs = [
    makeWrapper
    p7zip
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp ${src}/briar-desktop.jar $out/lib/
    makeWrapper ${openjdk}/bin/java $out/bin/briar-desktop \
      --add-flags "-jar $out/lib/briar-desktop.jar"
  '';

  fixupPhase = ''
    # Replace the embedded Tor binary (which is in a Tar archive)
    # with one from Nixpkgs.
    cp ${briar-tor} ./tor
    for arch in {aarch64,armhf,x86_64}; do
      7z a tor_linux-$arch.zip tor
      7z a $out/lib/briar-desktop.jar tor_linux-$arch.zip
    done
  '';

  meta = with lib; {
    description = "Decentalized and secure messnger";
    homepage = "https://code.briarproject.org/briar/briar-desktop";
    license = licenses.gpl3;
    maintainers = with maintainers; [ onny ];
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
  };
}
