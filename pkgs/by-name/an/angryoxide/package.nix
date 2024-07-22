{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, sqlite
, zlib
, stdenv
, darwin
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "angryoxide";
  version = "0.8.13";

  src = fetchFromGitHub {
    owner = "Ragnt";
    repo = "AngryOxide";
    rev = "v${version}";
    hash = "sha256-7H/h74hbC4E183zcAaLYh1CXwZ687VFGiIGHsRVyStw=";
  };

  cargoHash = "sha256-pXRYiJW4a5AfAolzhM6diMS0AvdQPg5lT7hdOM0QlwI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    sqlite
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ] ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  meta = {
    description = "802.11 Attack Tool";
    homepage = "https://github.com/Ragnt/AngryOxide/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fvckgrimm ];
    mainProgram = "angryoxide";
  };
}
