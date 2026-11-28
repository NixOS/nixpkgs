{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-source-switcher";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-switcher";
    tag = finalAttrs.version;
    hash = "sha256-XLeDFyb75gipHakYPMa3hRjlSF/20Tq+Dks3qw9c6iA=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ obs-studio ];

  cmakeFlags = [ "-DBUILD_OUT_OF_TREE=On" ];

  postInstall = ''
    rm -rf $out/obs-plugins $out/data
  '';

  meta = {
    description = "Plugin for OBS Studio to switch between a list of sources";
    homepage = "https://github.com/exeldro/obs-source-switcher";
    maintainers = with lib.maintainers; [ flexiondotorg ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
})
