{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  fontconfig,
  zlib,
  icu,
  libX11,
  libXext,
  libXi,
  libXrandr,
  libICE,
  libSM,
  openssl,
  unzip,
  xdg-utils,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "muse-sounds-manager";
  version = "2.0.4.872";

  # Use web.archive.org since upstream does not provide a stable (versioned) URL.
  # To see if there are new versions on the Web Archive, visit
  # http://web.archive.org/cdx/search/cdx?url=https://muse-cdn.com/Muse_Sounds_Manager_x64.tar.gz
  # then replace the date in the URL below with date when the SHA1
  # changes (currently QLR46LKDOAPB7VSF45HEAXWVNWFJHITG) and replace
  # the version above with the version in the .deb metadata (or in the
  # settings of muse-sounds-manager).
  src = fetchurl {
    url = "https://web.archive.org/web/20250729165100if_/https://muse-cdn.com/Muse_Sounds_Manager_x64.tar.gz";
    hash = "sha256-VcLBXpLDk90yd0j9NIzBOXXAciSLWP9y5X51L2/9W4A=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    stdenv.cc.cc
    zlib
  ]
  ++ runtimeDependencies;

  runtimeDependencies = map lib.getLib [
    icu
    libX11
    libXext
    libXi
    libXrandr
    libICE
    libSM
    openssl
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/share/applications $out/share/icons
    cp -p -R bin/ $out/
    cp -p res/*.desktop $out/share/applications
    cp -p -R res/icons $out/share

    runHook postInstall
  '';

  postInstall = ''
    ln -s ${xdg-utils}/bin/xdg-open $out/bin/open
    wrapProgram $out/bin/muse-sounds-manager \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
  '';

  dontStrip = true;

  meta = {
    description = "Manage Muse Sounds (Muse Hub) libraries for MuseScore";
    homepage = "https://musescore.org/";
    license = lib.licenses.unfree;
    mainProgram = "muse-sounds-manager";
    maintainers = with lib.maintainers; [
      orivej
      sarunint
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
