{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-source-clone";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-clone";
    tag = finalAttrs.version;
    hash = "sha256-It/TF7vAVzuANcNUG9whK9ZDLXpRHzwpGvV5I/YTVdo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ obs-studio ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_OUT_OF_TREE" true)
  ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = {
    description = "Plugin for OBS Studio to clone sources";
    homepage = "https://github.com/exeldro/obs-source-clone";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
