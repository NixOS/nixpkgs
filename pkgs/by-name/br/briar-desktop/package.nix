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
stdenv.mkDerivation (finalAttrs: {
  pname = "briar-desktop";
  version = "0.6.4-beta";

  src = fetchurl {
    url = "https://desktop.briarproject.org/jars/linux/${finalAttrs.version}/briar-desktop-linux-${finalAttrs.version}.jar";
    hash = "sha256-S7O625SWbgi4iby76Qe377NGiw4r9+VqgQh8kclKwMo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    p7zip
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp ${finalAttrs.src} $out/lib/briar-desktop.jar
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

  # TODO: Add a custom update script
  meta = {
    description = "Decentralized and secure messenger";
    mainProgram = "briar-desktop";
    homepage = "https://code.briarproject.org/briar/briar-desktop";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      onny
      supinie
    ];
    teams = with lib.teams; [ ngi ];
    platforms = [ "x86_64-linux" ];
  };
})
