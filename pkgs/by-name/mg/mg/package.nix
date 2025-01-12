{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  buildPackages,
}:

stdenv.mkDerivation {
  pname = "mg";
  version = "7.3-unstable-2024-06-04";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = "mg";
    rev = "4d4abcfc793554dbd4effdba8a3cc28ce2654c33";
    hash = "sha256-+sp8Edu5UWv73TCNVZTeH5rl2Q5XarYrlTYHuQsroVs=";
  };

  postPatch = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace configure --replace "./conftest" "echo"
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  ];

  installPhase = ''
    install -m 555 -Dt $out/bin mg
    install -m 444 -Dt $out/share/man/man1 mg.1
  '';
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Micro GNU/emacs, a portable version of the mg maintained by the OpenBSD team";
    homepage = "https://man.openbsd.org/OpenBSD-current/man1/mg.1";
    license = licenses.publicDomain;
    mainProgram = "mg";
    platforms = platforms.all;
  };
}
