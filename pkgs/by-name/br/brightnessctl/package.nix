{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  systemd,
  coreutils,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "brightnessctl";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Hummer12007";
    repo = "brightnessctl";
    tag = version;
    sha256 = "0immxc7almmpg80n3bdn834p3nrrz7bspl2syhb04s3lawa5y2lq";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "pkg-config" "$PKG_CONFIG"

    substituteInPlace 90-brightnessctl.rules \
      --replace-fail /bin/ ${coreutils}/bin/
  '';

  makeFlags = [
    "PREFIX="
    "DESTDIR=$(out)"
    "ENABLE_SYSTEMD=1"
  ];

  installTargets = [
    "install"
    "install_udev_rules"
  ];

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ systemd ];

  doInstallCheck = true;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Hummer12007/brightnessctl";
    description = "This program allows you read and control device brightness";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ megheaiulian ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://github.com/Hummer12007/brightnessctl";
    description = "This program allows you read and control device brightness";
    license = licenses.mit;
    maintainers = with maintainers; [ megheaiulian ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "brightnessctl";
  };

}
