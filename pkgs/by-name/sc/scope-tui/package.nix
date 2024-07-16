{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libpulseaudio
}:
rustPlatform.buildRustPackage {
  pname = "scope-tui";
  version = "0-unstable-2024-03-16";

  src = fetchFromGitHub {
    owner = "alemidev";
    repo = "scope-tui";
    rev = "299efd70129eb945f8ce63ff853decb41ef5e7ef";
    hash = "sha256-ELcNSjie/AGrPFT06VXR5mNxiBPwYGVzeC8I9ybN8Bc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpulseaudio ];

  meta = with lib; {
    description = "Simple oscilloscope/vectorscope/spectroscope for your terminal";
    homepage = "https://github.com/alemidev/scope-tui";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "scope-tui";
    platforms = platforms.linux;
  };
}
