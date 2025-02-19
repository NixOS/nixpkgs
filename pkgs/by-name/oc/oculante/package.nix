{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  fontconfig,
  nasm,
  libX11,
  libXcursor,
  libXrandr,
  libXi,
  libGL,
  libxkbcommon,
  wayland,
  stdenv,
  gtk3,
  darwin,
  perl,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage rec {
  pname = "oculante";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "woelper";
    repo = "oculante";
    rev = version;
    hash = "sha256-6jow0ektqmEcwFEaJgPqhJPs8LlYmPRLE+zqk1T4wDk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MQ9nTWRYONZP6ZrMVrwKqbyTpWeyQNzFFcnNzwj1z8M=";

  nativeBuildInputs = [
    cmake
    pkg-config
    nasm
    perl
    wrapGAppsHook3
  ];

  buildInputs =
    [
      openssl
      fontconfig
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libGL
      libX11
      libXcursor
      libXi
      libXrandr
      gtk3
      libxkbcommon
      wayland
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.libobjc
    ];

  checkFlags = [
    "--skip=bench"
    "--skip=tests::net" # requires network access
    "--skip=tests::flathub"
  ];

  postInstall = ''
    install -Dm444 $src/res/icons/icon.png $out/share/icons/hicolor/128x128/apps/oculante.png
    install -Dm444 $src/res/oculante.desktop -t $out/share/applications
    wrapProgram $out/bin/oculante \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            libGL
            libxkbcommon
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [ wayland ]
        )
      }
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Minimalistic crossplatform image viewer written in Rust";
    homepage = "https://github.com/woelper/oculante";
    changelog = "https://github.com/woelper/oculante/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "oculante";
    maintainers = with lib.maintainers; [
      dit7ya
      figsoda
    ];
  };
}
