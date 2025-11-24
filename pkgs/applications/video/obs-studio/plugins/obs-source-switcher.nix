{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
}:

stdenv.mkDerivation {
  pname = "obs-source-switcher";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-source-switcher";
    rev = "b229f40faceb0bb39cea41ce0ce2f2f236c0cbd1";
    hash = "sha256-5io2uMvPdHQAWFDqLyXLC6nxTEjkrk8v4v8XwGsPF7U=";
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
}
