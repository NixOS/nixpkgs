{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  systemd,
  glib,
  gtk3,
  dfu-util,
  blisp,
  fontconfig,
  libxkbcommon,
  libGL,
}:
rustPlatform.buildRustPackage rec {
  pname = "pineflash";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "Spagett1";
    repo = "pineflash";
    tag = version;
    hash = "sha256-4tcwEok36vuXbtlZNUkLNw1kHFQPBEJM/gWRhRWNLPg=";
  };

  cargoHash = "sha256-l01It6mUflENlADW6PpOQvK1o4qOjbTsMLB6n+OIl0U=";

  patches = [
    ./fix_pkexec_path.patch
  ];

  postInstall = ''
    mkdir -p "$out/share/applications"
    cp ./assets/Pineflash.desktop "$out/share/applications/Pineflash.desktop"
    mkdir -p "$out/share/pixmaps"
    cp ./assets/pine64logo.png "$out/share/pixmaps/pine64logo.png"
  '';

  postPatch = ''
    # Linux
    substituteInPlace src/submodules/flash.rs \
      --replace-fail 'let blisppath = "blisp";' 'let blisppath = "${blisp}/bin/blisp";' \
      --replace-fail 'let dfupath = "dfu-util";' 'let dfupath = "${dfu-util}/bin/dfu-util";'
    # Darwin
    substituteInPlace src/submodules/flash.rs \
      --replace-fail 'Command::new("blisp")' 'Command::new("${blisp}/bin/blisp")' \
      --replace-fail 'Command::new("dfu-util")' 'Command::new("${dfu-util}/bin/dfu-util")'
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    systemd
    glib
    gtk3
    fontconfig
    libxkbcommon
    libGL
    dfu-util
    blisp
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/bin/pineflash --add-rpath ${libxkbcommon}/lib
    patchelf $out/bin/pineflash --add-rpath ${libGL}/lib
  '';

  meta = {
    description = "GUI tool to flash IronOS to the Pinecil V1 and V2";
    homepage = "https://github.com/Spagett1/pineflash";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      acuteaangle
    ];
    mainProgram = "pineflash";
  };
}
