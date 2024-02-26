{ lib
, stdenv
, rustPlatform
, rustc
, fetchFromGitHub
, openssl
, pkg-config
}:
rustPlatform.buildRustPackage rec {
  pname = "cosh";
  version = "0.1-unstable-2024-01-27";
  src = fetchFromGitHub {
    repo = "cosh";
    owner = "tomhrr";
    rev = "540d3b99908dc2603887f64e288ac18b7f53cb37";
    hash = "sha256-O+DnXMFVHgPBQcuOmvtyMKEYYwCC9fFY594pEWgU2HM=";
  };

  # the tests try to read /etc/localtime which is unavailable under the sandbox
  doCheck = false;

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ openssl ];

  cargoPatches = [ ./cargo-lock.patch ];

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildPhase = ''
    runHook preBuild
    make prefix=$out all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make prefix=$out install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/tomhrr/cosh";
    description = "A concatenative command-line shell written in Rust";
    license = licenses.bsd3;
    maintainers = with maintainers; [ binarycat ];
    platforms = platforms.linux;
  };
}
