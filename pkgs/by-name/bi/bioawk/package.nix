{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  bison,
  zlib,
}:

stdenv.mkDerivation {
  pname = "bioawk";
  version = "unstable-2017-09-11";

  src = fetchFromGitHub {
    owner = "lh3";
    repo = "bioawk";
    rev = "fd40150b7c557da45e781a999d372abbc634cc21";
    hash = "sha256-WWgz96DPP83J45isWkMbgEvOlibq6WefK//ImV6+AU0=";
  };

  nativeBuildInputs = [
    bison
    installShellFiles
  ];

  buildInputs = [
    zlib
  ];

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 bioawk -t $out/bin
    mv awk.1 bioawk.1
    installManPage bioawk.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "BWK awk modified for biological data";
    mainProgram = "bioawk";
    homepage = "https://github.com/lh3/bioawk";
    license = licenses.hpnd;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
