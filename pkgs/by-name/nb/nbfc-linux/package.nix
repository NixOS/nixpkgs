{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nbfc-linux";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "nbfc-linux";
    repo = "nbfc-linux";
    rev = "${finalAttrs.version}";
    hash = "sha256-+xYr2uIxfMaMAaHGvvA+0WPZjwj3wVAc34e1DWsJLqE=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];
  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--sysconfdir=${placeholder "out"}/etc"
    "--bindir=${placeholder "out"}/bin"
  ];

  meta = {
    description = "C port of Stefan Hirschmann's NoteBook FanControl";
    longDescription = ''
      nbfc-linux provides fan control service for notebooks
    '';
    homepage = "https://github.com/nbfc-linux/nbfc-linux";
    license = lib.licenses.gpl3;
    maintainers = [lib.maintainers.Celibistrial];
    mainProgram = "nbfc";
    platforms = lib.platforms.linux;
  };
})
