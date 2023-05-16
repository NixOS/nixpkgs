<<<<<<< HEAD
{ stdenv
, lib
, fetchFromGitHub
, cargo
, pkg-config
, rustPlatform
, bzip2
, curl
, zlib
, zstd
, libiconv
, CoreServices
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-cinnabar";
  version = "0.6.2";
=======
{ stdenv, lib, fetchFromGitHub, cargo, pkg-config, rustPlatform
, bzip2, curl, zlib, zstd, libiconv, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "git-cinnabar";
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "glandium";
    repo = "git-cinnabar";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-1Y4zd4rYNRatemDXRMkQQwBJdkfOGfDWk9QBvJOgi7s=";
=======
    rev = version;
    sha256 = "VvfoMypiFT68YJuGpEyPCxGOjdbDoF6FXtzLWlw0uxY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
<<<<<<< HEAD
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    bzip2
    curl
    zlib
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    CoreServices
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-p85AS2DukUzEbW9UGYmiF3hpnZvPrZ2sRaeA9dU8j/8=";
=======
    pkg-config rustPlatform.cargoSetupHook cargo
  ];

  buildInputs = [ bzip2 curl zlib zstd ]
    ++ lib.optionals stdenv.isDarwin [ libiconv CoreServices ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sha256 = "GApYgE7AezKmcGWNY+dF1Yp1TZmEeUdq3CsjvMvo/Rw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ZSTD_SYS_USE_PKG_CONFIG = true;

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
<<<<<<< HEAD

    mkdir -p $out/bin
    install -v target/release/git-cinnabar $out/bin
    ln -sv git-cinnabar $out/bin/git-remote-hg

    runHook postInstall
  '';

  meta = {
    description = "git remote helper to interact with mercurial repositories";
    homepage = "https://github.com/glandium/git-cinnabar";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = lib.platforms.all;
  };
})
=======
    mkdir -p $out/bin
    install -v target/release/git-cinnabar $out/bin
    ln -sv git-cinnabar $out/bin/git-remote-hg
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/glandium/git-cinnabar";
    description = "git remote helper to interact with mercurial repositories";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.all;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
