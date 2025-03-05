{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nbfc-linux";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "nbfc-linux";
    repo = "nbfc-linux";
    rev = "${finalAttrs.version}";
    hash = "sha256-1tLW/xEh01y8BjVbgIa95DkYWf7CDVSo/lI/1U28Xs8=";
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
