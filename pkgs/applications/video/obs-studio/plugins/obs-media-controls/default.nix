{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
  qtbase,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-media-controls";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-media-controls";
    tag = finalAttrs.version;
    hash = "sha256-CElK9e+wpnMiup6DwdQpQfVMm6atXvz+JYHsGnv3lFo=";
  };

  patches = [
    # Fix cmake build with qt 6.10
    # Submitted upstream: https://github.com/exeldro/obs-media-controls/pull/28
    ./fix-cmake.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    obs-studio
    qtbase
  ];

  dontWrapQtApps = true;

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = {
    description = "Plugin for OBS Studio to add a Media Controls dock";
    homepage = "https://github.com/exeldro/obs-media-controls";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
