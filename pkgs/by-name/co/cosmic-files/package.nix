{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, makeBinaryWrapper
, cosmic-icons
, just
, pkg-config
, libxkbcommon
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-files";
  version = "unstable-2024-02-28";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "6123108f3ae3c7074264184952f0a53e49a981d5";
    hash = "sha256-BeqpoLIZbR5Dg7OGYGQMFWBLdD96n4t7fX8Ju9/h5JU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-ksaYMGT/oug7isQY8/1WD97XDUsX2ShBdabUzxWffYw=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "cosmic-config-0.1.0" = "sha256-eaG/HCwlKqSfEp6GEPeBS63j5WHq4qdYTNHqnW2zeeE=";
      "cosmic-text-0.11.2" = "sha256-Y9i5stMYpx+iqn4y5DJm1O1+3UIGp0/fSsnNq3Zloug=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "systemicons-0.7.0" = "sha256-zzAI+6mnpQOh+3mX7/sJ+w4a7uX27RduQ99PNxLNF78=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  # COSMIC applications now uses vergen for the About page
  # Update the COMMIT_DATE to match when the commit was made
  env.VERGEN_GIT_COMMIT_DATE = "2024-02-28";
  env.VERGEN_GIT_SHA = src.rev;

  postPatch = ''
    substituteInPlace justfile --replace '#!/usr/bin/env' "#!$(command -v env)"
  '';

  nativeBuildInputs = [ just pkg-config makeBinaryWrapper ];
  buildInputs = [ wayland ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
  ];

  # LD_LIBRARY_PATH can be removed once tiny-xlib is bumped above 0.2.2
  postInstall = ''
    wrapProgram "$out/bin/${pname}" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi wayland libxkbcommon ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ahoneybun nyanbinary ];
    platforms = platforms.linux;
  };
}
