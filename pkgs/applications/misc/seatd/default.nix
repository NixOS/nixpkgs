{ fetchFromSourcehut
, lib
, meson
, ninja
, pkg-config
, scdoc
, stdenv
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "seatd";
  version = "0.8.0";
=======
stdenv.mkDerivation rec {
  pname = "seatd";
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "seatd";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-YaR4VuY+wrzbnhER4bkwdm0rTY1OVMtixdDEhu7Lnws=";
=======
    rev = version;
    sha256 = "sha256-m8xoL90GI822FTgCXuVr3EejLAMUStkPKVoV7w8ayIE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "bin" "out" "dev" "man" ];

<<<<<<< HEAD
  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];
=======
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals systemdSupport [ systemd ];

  mesonFlags = [
    "-Dlibseat-logind=${if systemdSupport then "systemd" else "disabled"}"
    "-Dlibseat-builtin=enabled"
    "-Dserver=enabled"
  ];

<<<<<<< HEAD
  meta = {
    description = "A universal seat management library";
    changelog = "https://git.sr.ht/~kennylevinsen/seatd/refs/${finalAttrs.version}";
    homepage = "https://sr.ht/~kennylevinsen/seatd/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emantor ];
    platforms = with lib.platforms; freebsd ++ linux ++ netbsd;
    mainProgram = "seatd";
  };
})
=======
  meta = with lib; {
    description = "A universal seat management library";
    changelog   = "https://git.sr.ht/~kennylevinsen/seatd/refs/${version}";
    homepage    = "https://sr.ht/~kennylevinsen/seatd/";
    license     = licenses.mit;
    platforms   = with platforms; freebsd ++ linux ++ netbsd;
    maintainers = with maintainers; [ emantor ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
