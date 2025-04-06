{
  lib,
  stdenv,
  fetchurl,
  openjdk,
  libnotify,
  makeWrapper,
  tor,
  p7zip,
  bash,
  writeScript,
  libGL,
}:
let

  briar-tor = writeScript "briar-tor" ''
    #! ${bash}/bin/bash
    exec ${tor}/bin/tor "$@"
  '';

in
stdenv.mkDerivation rec {
  pname = "briar-desktop";
  version = "0.6.3-beta";

  src = fetchurl {
    url = "https://desktop.briarproject.org/jars/linux/${version}/briar-desktop-linux-${version}.jar";
    hash = "sha256-8JX4cgRJZDCBlu5iVL7t5nZSZn8XTk3DU3rasViQgtg=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    p7zip
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp ${src} $out/lib/briar-desktop.jar
    makeWrapper ${openjdk}/bin/java $out/bin/briar-desktop \
      --add-flags "-jar $out/lib/briar-desktop.jar" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libnotify
          libGL
        ]
      }"
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
    description = "Decentralized and secure messenger";
    mainProgram = "briar-desktop";
    homepage = "https://code.briarproject.org/briar/briar-desktop";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      onny
      supinie
    ];
    platforms = [ "x86_64-linux" ];
  };
}
