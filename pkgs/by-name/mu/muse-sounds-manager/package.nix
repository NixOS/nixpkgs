{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  fontconfig,
  zlib,
  icu,
  libx11,
  libxext,
  libxi,
  libxrandr,
  libice,
  libsm,
  openssl,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "muse-sounds-manager";
  version = "2.2.1.953";

  # Permalink from https://support.musehub.com/en/articles/15070607-changelog
  src = fetchurl {
    url = "https://muse-cdn.com/muse-sounds-manager/Muse_Sounds_Manager_x64_${finalAttrs.version}.tar.gz";
    hash = "sha256-y7fKHh2pG8uT4p0vq20rsW8bSAp1mepkd2sW/06N3EI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    fontconfig
    stdenv.cc.cc
    zlib
  ]
  ++ finalAttrs.runtimeDependencies;

  runtimeDependencies = map lib.getLib [
    icu
    libx11
    libxext
    libxi
    libxrandr
    libice
    libsm
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
  '';

  dontStrip = true;

  meta = {
    description = "Manage Muse Sounds (Muse Hub) libraries for MuseScore";
    homepage = "https://musescore.org/";
    license = lib.licenses.unfree;
    mainProgram = "muse-sounds-manager";
    maintainers = with lib.maintainers; [
      sarunint
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
