{ stdenvNoCC
, stdenv
, lib
, dpkg
, autoPatchelfHook
, makeWrapper
, fetchurl
, alsa-lib
, openssl
, udev
, libglvnd
, libX11
, libXcursor
, libXi
, libXrandr
, libXfixes
, libpulseaudio
, libva
, ffmpeg_6
, libpng
, libjpeg8
, curl
, vulkan-loader
, zenity
}:

stdenvNoCC.mkDerivation {
  pname = "parsec-bin";
  version = "150_95";

  src = fetchurl {
    url = "https://web.archive.org/web/20240725203323/https://builds.parsec.app/package/parsec-linux.deb";
    sha256 = "sha256-9F56u+jYj2CClhbnGlLi65FxS1Vq00coxwu7mjVTY1w=";
  };

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  nativeBuildInputs = [ dpkg autoPatchelfHook makeWrapper ];

  buildInputs = [
    stdenv.cc.cc # libstdc++
    libglvnd
    libX11
  ];

  runtimeDependenciesPath = lib.makeLibraryPath [
    stdenv.cc.cc
    libglvnd
    openssl
    udev
    alsa-lib
    libpulseaudio
    libva
    ffmpeg_6
    libpng
    libjpeg8
    curl
    libX11
    libXcursor
    libXi
    libXrandr
    libXfixes
    vulkan-loader
  ];

  binPath = lib.makeBinPath [
    zenity
  ];

  prepareParsec = ''
    if [[ ! -e "$HOME/.parsec/appdata.json" ]]; then
      mkdir -p "$HOME/.parsec"
      cp --no-preserve=mode,ownership,timestamps ${placeholder "out"}/share/parsec/skel/* "$HOME/.parsec/"
    fi
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv usr/* $out

    wrapProgram $out/bin/parsecd \
      --prefix PATH : "$binPath" \
      --prefix LD_LIBRARY_PATH : "$runtimeDependenciesPath" \
      --run "$prepareParsec"

    substituteInPlace $out/share/applications/parsecd.desktop \
      --replace "/usr/bin/parsecd" "parsecd" \
      --replace "/usr/share/icons" "${placeholder "out"}/share/icons"

    runHook postInstall
  '';

  # Only the main binary needs to be patched, the wrapper script handles
  # everything else. The libraries in `share/parsec/skel` would otherwise
  # contain dangling references when copied out of the nix store.
  dontAutoPatchelf = true;

  fixupPhase = ''
    runHook preFixup

    autoPatchelf $out/bin

    runHook postFixup
  '';

  meta = with lib; {
    homepage = "https://parsec.app/";
    changelog = "https://parsec.app/changelog";
    description = "Remote streaming service client";
    license = licenses.unfree;
    maintainers = with maintainers; [ arcnmx pabloaul ];
    platforms = platforms.linux;
    mainProgram = "parsecd";
  };
}
