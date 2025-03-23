{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libcaption,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-replay-source";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-replay-source";
    tag = finalAttrs.version;
    hash = "sha256-0IBH4Wb4dbbwqu7DsMb/pfnA8dYRbsW7cBW2XTjQK0U=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libcaption
    obs-studio
    qtbase
  ];

  postInstall = ''
    mkdir -p $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Replay source for OBS studio";
    homepage = "https://github.com/exeldro/obs-replay-source";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pschmitt ];
  };
})
