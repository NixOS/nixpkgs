{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libpcap,
  libxcrypt,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation {
  pname = "asleap";
<<<<<<< HEAD
  version = "0-unstable-2021-06-21";
=======
  version = "0-unstable-2021-06-20";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zackw";
    repo = "asleap";
    rev = "eb3bd42098cba42b65f499c9d8c73d890861b94f";
    hash = "sha256-S6jS0cg9tHSfmP6VHyISkXJxczhPx3HDdxT46c+YmE8=";
  };

  buildInputs = [
    openssl
    libpcap
    libxcrypt
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 asleap $out/bin/asleap
    install -Dm755 genkeys $out/bin/genkeys

    runHook postInstall
  '';

<<<<<<< HEAD
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=zack/no-external-crypto" ];
  };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    homepage = "https://github.com/zackw/asleap";
    description = "Recovers weak LEAP and PPTP passwords";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ pyrox0 ];
<<<<<<< HEAD
    mainProgram = "asleap";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.linux;
  };
}
