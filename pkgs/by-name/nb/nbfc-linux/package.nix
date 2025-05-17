{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbfc-linux";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "nbfc-linux";
    repo = "nbfc-linux";
    tag = "${finalAttrs.version}";
    hash = "sha256-vbpdBYrH8sf62UjVfSiJEwEDpKagGw8FIHkIBKwjy1Q=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ curl ];

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
    maintainers = [ lib.maintainers.Celibistrial ];
    mainProgram = "nbfc";
    platforms = lib.platforms.linux;
  };
})
