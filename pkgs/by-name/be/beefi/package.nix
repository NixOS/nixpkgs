{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  binutils-unwrapped,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "beefi";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jfeick";
    repo = "beefi";
    tag = version;
    sha256 = "1180avalbw414q1gnfqdgc9zg3k9y0401kw9qvcn51qph81d04v5";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    binutils-unwrapped
    systemd
  ];

  patchPhase = ''
    substituteInPlace beefi \
      --replace objcopy ${binutils-unwrapped}/bin/objcopy \
      --replace /usr/lib/systemd ${systemd}/lib/systemd
  '';

  installPhase = ''
    install -Dm755 beefi $out/bin/beefi
    installManPage beefi.1
  '';

<<<<<<< HEAD
  meta = {
    description = "Small script to create bootable EFISTUB kernel images";
    mainProgram = "beefi";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tu-maurice ];
=======
  meta = with lib; {
    description = "Small script to create bootable EFISTUB kernel images";
    mainProgram = "beefi";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tu-maurice ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/jfeick/beefi";
  };
}
