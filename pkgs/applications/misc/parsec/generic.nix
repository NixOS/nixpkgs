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
, ffmpeg_5
, libpng
, libjpeg8
, curl
, vulkan-loader
, gnome
, zenity ? gnome.zenity
, darwin
, p7zip
, libarchive
}:

{ pname
, version
, url
, hash
}:

stdenvNoCC.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    inherit url hash;
  };

  unpackPhase = lib.optionalString stdenv.isLinux
  ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  ''
  + lib.optionalString stdenv.isDarwin
  ''
    7z x $src
    bsdtar -xf Payload~
  '';

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    dpkg
    autoPatchelfHook
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [
    libarchive
    p7zip
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc # libstdc++
    libglvnd
    libX11
  ];

  runtimeDependenciesPath = lib.optionalString stdenv.isLinux
  (lib.makeLibraryPath [
    stdenv.cc.cc
    libglvnd
    openssl
    udev
    alsa-lib
    libpulseaudio
    libva
    ffmpeg_5
    libpng
    libjpeg8
    curl
    libX11
    libXcursor
    libXi
    libXrandr
    libXfixes
    vulkan-loader
  ]);

  binPath = lib.makeBinPath [
    zenity
  ];

  prepareParsec = ''
    if [[ ! -e "$HOME/.parsec/appdata.json" ]]; then
      mkdir -p "$HOME/.parsec"
      cp --no-preserve=mode,ownership,timestamps ${placeholder "out"}/share/parsec/skel/* "$HOME/.parsec/"
    fi
  '';

  installPhase = lib.optionalString stdenv.isLinux ''
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
  ''
  + lib.optionalString stdenv.isDarwin
  ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R Parsec.app $out/Applications/

    runHook postInstall
  '';
  # Only the main binary needs to be patched, the wrapper script handles
  # everything else. The libraries in `share/parsec/skel` would otherwise
  # contain dangling references when copied out of the nix store.
  dontAutoPatchelf = true;

  fixupPhase = lib.optionalString stdenv.isLinux ''
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
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "parsecd";
  };
}
