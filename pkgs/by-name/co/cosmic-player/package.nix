{ 
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  alsa-lib,
  cosmic-icons,
  ffmpeg,
  llvmPackages,
  just,
  pkg-config,
  libxkbcommon,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-player";
  version = "0-unstable-2024-06-10";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-player";
    rev = "afcb8c72bc0fc4022ebc68393056e9578bfe8db0";
    hash = "sha256-JEKEZ3Vb41CKKCwd/AJam26GgfUIGH3kc5kzOiinsj8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" =
        "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" =
        "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" =
        "sha256-RVUsezjeJ3EGsD+zTWMwxLP+0HvbxFKuuW6JivWfCKE=";
      "cosmic-text-0.11.2" =
        "sha256-2TfgUaxyRBrf9EpcdOzrwQltoI9/Od29itrxldZ5KGw=";
      "clipboard_macos-0.1.0" =
        "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "softbuffer-0.4.1" =
        "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "smithay-client-toolkit-0.18.0" =
        "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" =
        "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs =
    [ just pkg-config makeBinaryWrapper rustPlatform.bindgenHook ];
  buildInputs = [ 
    wayland 
    libxkbcommon 
    alsa-lib 
    ffmpeg 
    llvmPackages.clang 
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set prefix ${placeholder "out"}"
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-player"
  ];

  # LD_LIBRARY_PATH can be removed once tiny-xlib is bumped above 0.2.2
  postInstall = ''
    wrapProgram "$out/bin/${pname}" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          xorg.libX11
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXi
          wayland
          libxkbcommon
        ]
      }
  '';

  meta = {
    homepage = "https://github.com/pop-os/cosmic-player";
    description = "Media Player for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jh-devv ];
    platforms = lib.platforms.linux;
  };
}
