{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libucontext";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "kaniini";
    repo = "libucontext";
    rev = "libucontext-${version}";
    hash = "sha256-MQCRRyA64MEtPoUtf1tFVbhiMDc4DlepSjMEFcb/Kh4=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/kaniini/libucontext";
    description = "ucontext implementation featuring glibc-compatible ABI";
    license = licenses.isc;
    platforms = platforms.linux;
    teams = [ teams.lix ];
  };
}
