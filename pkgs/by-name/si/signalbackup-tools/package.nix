{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  darwinMinVersionHook,
  dbus,
  openssl,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "signalbackup-tools";
<<<<<<< HEAD
  version = "20251214";
=======
  version = "20251110";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bepaald";
    repo = "signalbackup-tools";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-/XmrlobVbbSN94cCj/HDLLd6x2sB7A3IF/cBAvX7rSY=";
=======
    hash = "sha256-3LGwd7LZO9XZjDDE1aDiWCHjR7rMOGWyd8RWt7iAa0Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (darwinMinVersionHook "13.3")
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp signalbackup-tools $out/bin/
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Tool to work with Signal Backup files";
    mainProgram = "signalbackup-tools";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.malo ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Tool to work with Signal Backup files";
    mainProgram = "signalbackup-tools";
    homepage = "https://github.com/bepaald/signalbackup-tools";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
