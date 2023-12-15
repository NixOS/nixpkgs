{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, fontconfig
, nasm
, libX11
, libXcursor
, libXrandr
, libXi
, libGL
, libxkbcommon
, wayland
, stdenv
, gtk3
, darwin
, perl
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "oculante";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "woelper";
    repo = pname;
    rev = version;
    hash = "sha256-uDSZ7qwDC/eR0aZN372ju21PBGuBiiYmlx/26Ta3luE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    nasm
    perl
    wrapGAppsHook
  ];

  checkFlagsArray = [ "--skip=tests::net" ]; # requires network access

  buildInputs = [
    openssl
    fontconfig
  ] ++ lib.optionals stdenv.isLinux [
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    gtk3

    libxkbcommon
    wayland
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
  ];

  checkFlags = [
    "--skip=bench"
  ];

  postInstall = ''
    install -Dm444 $src/res/oculante.png -t $out/share/icons/hicolor/128x128/apps/
    install -Dm444 $src/res/oculante.desktop -t $out/share/applications
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/oculante --add-rpath ${lib.makeLibraryPath [ libxkbcommon libX11 ]}
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A minimalistic crossplatform image viewer written in Rust";
    homepage = "https://github.com/woelper/oculante";
    changelog = "https://github.com/woelper/oculante/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "oculante";
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
