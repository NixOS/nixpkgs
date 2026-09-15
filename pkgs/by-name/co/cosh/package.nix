{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, unstableGitUpdater
}:
rustPlatform.buildRustPackage rec {
  pname = "cosh";
  version = "unstable-2024-02-23";
  src = fetchFromGitHub {
    repo = "cosh";
    owner = "tomhrr";
    rev = "e13702dc77c63dc91df305d2abf5bbdd87809781";
    hash = "sha256-4zsTK2kAELM/A3WEob9MDt++wowFhrDJwPEtR9QZ4oU=";#sha256-4zsTK2kAELM/A3WEob9MDt++wowFhrDJwPEtR9QZ4oU=";
  };

  # the tests try to read /etc/localtime which is unavailable under the sandbox
  doCheck = false;

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ openssl ];

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

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

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    homepage = "https://github.com/tomhrr/cosh";
    description = "A concatenative command-line shell written in Rust";
    license = licenses.bsd3;
    maintainers = with maintainers; [ binarycat ];
    platforms = platforms.linux;
    mainProgram = "cosh";
  };
}
