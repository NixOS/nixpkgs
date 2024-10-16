{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  pkg-config,
  wayland,
  libxkbcommon,
  just,
  cosmic-icons,
}:
let
  commitDate = "2024-09-07";
in
rustPlatform.buildRustPackage rec {
  pname = "cosmic-calculator";
  version = "unstable-${commitDate}";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "calculator";
    rev = "1c356fd33be714d00d6533fde747ce7f515bd3f0";
    hash = "sha256-T6V50a6SBvumIWduSxtg0rbcy1LliZn7oLo6al0OPQQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-config-0.1.0" = "sha256-AmgRihxFMq6pQotz/Qqbzo04dVGkxx1pSiQwfBG3kjY=";
      "cosmic-settings-daemon-0.1.0" = "sha256-QAFlbT66P7MDFJf+BFrCwUqNinEAcXpimqVa59OaAh8=";
      "cosmic-text-0.12.1" = "sha256-sZjYGyGRu9sg81SdCw44I0/re/BtSyz/tSZPgM6cl70=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [
    just
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    wayland
    libxkbcommon
  ];

  dontUseJustBuild = true;

  env = {
    VERGEN_GIT_COMMIT_DATE = commitDate;
    VERGEN_GIT_SHA = src.rev;
  };

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/${meta.mainProgram}"
  ];

  postFixup = ''
    wrapProgram $out/bin/${meta.mainProgram} \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxkbcommon
          wayland
        ]
      }"
  '';

  meta = {
    description = "Calculator for the COSMIC desktop";
    homepage = "https://github.com/cosmic-utils/calculator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ callumio ];
    mainProgram = "cosmic-ext-calculator";
    platforms = lib.platforms.linux;
  };
}
