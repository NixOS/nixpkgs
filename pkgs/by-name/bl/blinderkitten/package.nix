{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  curl,
  freetype,
  libx11,
  libxinerama,
  libxrandr,
  libxcursor,
  libxcomposite,
  mesa,
  alsa-lib,
  freeglut,
  jack2,
  bluez,
  gtk3,
  webkitgtk_4_1,
  sdl3,
  fuse2,
  libusb1,
  hidapi,
  ladspa-header,
  openssl,
  avahi,
  nix-update-script,
}:

let
  juce = fetchFromGitHub {
    owner = "norbertrostaing";
    repo = "JUCE";
    rev = "develop-local";
    hash = "sha256-Dk66pXlJ/B9ezsDVqV0cxSNkqPVb2fqo4YGoCrCCHOE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "blinderkitten";
  version = "1.0.1b97";

  src = fetchFromGitHub {
    owner = "norbertrostaing";
    repo = "BlinderKitten";
    tag = finalAttrs.version;
    hash = "sha256-8OT4tZXR01IOndVuCWJgSGLeyq5rxuFRcc1ZBWQKaZE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];

  makeFlags = [
    "-j2"
    "CONFIG=Release"
  ];

  # https://github.com/norbertrostaing/BlinderKitten/blob/295380b51208f66756c5eda758c76284ac036c29/.github/workflows/build.yml#L199
  buildInputs = [
    curl
    freetype
    libx11
    libxinerama
    libxrandr
    libxcursor
    libxcomposite
    mesa
    alsa-lib
    freeglut
    jack2
    bluez
    gtk3
    webkitgtk_4_1
    sdl3
    fuse2
    libusb1
    hidapi
    ladspa-header
    openssl
    avahi
  ];

  # Patch nixpkgs webkitgtk version
  # Patch avahi pkg-config; Fixing a missing lib during linking
  postPatch = ''
    ln -s ${juce} JUCE
    substituteInPlace ./Builds/LinuxMakefile/Makefile \
      --replace-fail "webkit2gtk-4.0" "webkit2gtk-4.1" \
      --replace-fail "shell \$(PKG_CONFIG) --libs" "shell \$(PKG_CONFIG) --libs avahi-client"
  '';

  # Move into build directory
  preBuild = ''
    cd ./Builds/LinuxMakefile/
  '';

  # Install files
  # Move binary
  # Move desktop item
  installPhase = ''
    mkdir $out
    cp -rvL BlinderKitten.AppDir/usr/* $out
    mkdir $out/share/applications
    cp -v build/BlinderKitten $out/bin
    cp -v BlinderKitten.AppDir/blinderkitten.desktop $out/share/applications
  '';

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A free lighting software without restriction";
    homepage = "https://blinderkitten.lighting/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tgi74 ];
    platforms = lib.platforms.linux;
    mainProgram = "BlinderKitten";
  };
})
