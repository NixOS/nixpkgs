{
  lib,
  fetchFromGitHub,
  alsa-lib,
  libGL,
  libgit2,
  libx11,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  nix-update-script,
  pkg-config,
  python3,
  rustPlatform,
  wayland,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snowemu";
  version = "1.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "twvd";
    repo = "snow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BA4uCuluSfIGXwBxE2X6Gke0ITsYEPzKoFDwx6jRYsk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    libgit2
    zstd
  ];

  cargoHash = "sha256-C7rCx0g77R+1f0la+j3pVW0bShGPdJD3btAIYg3yzMw=";

  env.CARGO_PROFILE_RELEASE_LTO = "fat";

  nativeCheckInputs = [ python3 ];

  preCheck = ''
    pushd testdata/m68000
    python3 decode.py
    popd
  '';

  postInstall = ''
    install -Dm644 assets/snow.desktop -t $out/share/applications
    install -Dm644 assets/snow_icon.png -t $out/share/icons/hicolor/1024x1024/apps
    install -Dm644 assets/dev.thomasw.snow.metainfo.xml -t $out/share/metainfo
    substituteInPlace $out/share/metainfo/dev.thomasw.snow.metainfo.xml \
      --replace-fail "/usr/share/icons" "$out/share/icons"
  '';

  postFixup = ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libGL
        libx11
        libxcursor
        libxi
        libxkbcommon
        libxrandr
        wayland
      ]
    } $out/bin/snowemu
  '';

  cargoTestFlags = [ "--workspace" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Early Macintosh emulator";
    longDescription = ''
      Snow emulates classic (Motorola 680x0-based) Macintosh computers. It features a graphical user interface to operate the emulated machine and provides extensive debugging capabilities. The aim of this project is to emulate the Macintosh on a hardware-level as much as possible, as opposed to emulators that patch the ROM or intercept system calls.
      It currently emulates the Macintosh 128K, Macintosh 512K, Macintosh Plus, Macintosh SE, Macintosh Classic and Macintosh II.
    '';
    homepage = "https://snowemu.com/";
    changelog = "https://github.com/twvd/snow/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nulleric ];
    platforms = lib.platforms.linux;
    mainProgram = "snowemu";
  };
})
