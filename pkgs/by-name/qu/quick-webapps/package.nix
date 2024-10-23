{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  cosmic-icons,
  just,
  pkg-config,
  libxkbcommon,
  openssl,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "quick-webapps";
  version = "0.4.6-unstable-2024-06-24";

  src = fetchFromGitHub {
    owner = "elevenhsoft";
    repo = "WebApps";
    rev = "5a8e29e09cd601379116b2d255ca10431714e094";
    hash = "sha256-D3ixt3nLClfPeByRjWT3JOQsovScfV1/EXqDeGN8Pkw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-temNg+RdvquSLAdkwU5b6dtu9vZkXjnDASS/eJo2rz8=";
      "cosmic-config-0.1.0" = "sha256-80einOpwpoBsJScgfd0O8yY5AdbjKazh6oQhs/w9L+w=";
      "cosmic-text-0.11.2" = "sha256-K2pZD+pnZvqiowo71ZSotjqiZDw0dZqWZKRLSVF2lCI=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-client-toolkit-0.18.0" = "sha256-/7twYMt5/LpzxLXAQKTGNnWcfspUkkZsN5hJu7KaANc=";
      "smithay-clipboard-0.8.0" = "sha256-MqzynFCZvzVg9/Ry/zrbH5R6//erlZV+nmQ2St63Wnc=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  # COSMIC applications now use vergen for the About page
  # Update the COMMIT_DATE to match when the commit was made
  env.VERGEN_GIT_COMMIT_DATE = "2024-08-03";
  env.VERGEN_GIT_SHA = src.rev;

  postPatch = ''
    substituteInPlace justfile --replace-fail '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [
    just
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    libxkbcommon
    openssl
    wayland
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/quick-webapps"
  ];

  # LD_LIBRARY_PATH can be removed once tiny-xlib is bumped above 0.2.2
  postInstall = ''
    wrapProgram "$out/bin/quick-webapps" \
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

  meta = with lib; {
    homepage = "https://github.com/elevenhsoft/WebApps";
    description = "Web applications at your fingertips";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun ];
    platforms = platforms.linux;
  };
}
