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
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "oculante";
  version = "0.6.63";

  src = fetchFromGitHub {
    owner = "woelper";
    repo = pname;
    rev = version;
    sha256 = "sha256-ynxGpx8LLcd4/n9hz/bbhpZUxqX1sPS7LFYPZ22hTxo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  patches = [
    # The commit below removes a hack that had been forcing X11,
    # even if the user explicitly set `WINIT_UNIX_BACKEND=wayland`!
    # The commit, which is merged upstream but unreleased, removes
    # that hack.
    (fetchpatch {
      url = "https://github.com/woelper/oculante/commit/6ee60dec0bd430970b3dee9508b4cbaa325c5892.patch";
      hash = "sha256-gvZ3ILsJqAA9x3f39sK7qltGbsu6/3XD8t8/QApJdRI=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    nasm
    perl
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

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/oculante --add-rpath ${lib.makeLibraryPath [ libxkbcommon libX11 ]}
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A minimalistic crossplatform image viewer written in Rust";
    homepage = "https://github.com/woelper/oculante";
    changelog = "https://github.com/woelper/oculante/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
