{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  libpulseaudio,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pamix";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "patroclos";
    repo = "pamix";
    tag = finalAttrs.version;
    hash = "sha256-7UPz6YpsnZHpW7sOJdJU2wQ5jyFPWTHxoknago0W+Ss=";
  };

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace-fail "/etc" "$out/etc/xdg"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libpulseaudio
    ncurses
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pulseaudio terminal mixer";
    homepage = "https://github.com/patroclos/PAmix";
    changelog = "https://github.com/patroclos/PAmix/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "pamix";
  };
})
