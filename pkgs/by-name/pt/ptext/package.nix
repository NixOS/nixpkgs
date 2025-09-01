{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "ptext";
  version = "0-unstable-2024-08-19";

  src = fetchFromGitHub {
    owner = "proh14";
    repo = "ptext";
    rev = "86cc1a165f398bd1f08fc45f2db93d4a9701ab0e";
    hash = "sha256-bmqQslC/T7dFJwg/ZCevQRpmkVJHRQ++0EV4b88xF6k=";
  };

  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ];

  makeFlags = [
    "INSTALL_DIR=${placeholder "out"}/bin"
    "MANPAGE_INSTALL_DIR=${placeholder "out"}/share/man/man1"
  ];

  preInstall = "mkdir -p $out/{bin,share/man/man1}";

  meta = {
    description = "Nano like text editor built with pure C";
    homepage = "https://github.com/proh14/ptext";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux;
    mainProgram = "ptext";
  };
}
