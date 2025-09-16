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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "exeldro";
    repo = "obs-media-controls";
    tag = "${finalAttrs.version}";
    hash = "sha256-r9fqpg0G9rzGSqq5FUS8ul58rj0796aGZIND8PCJ9jk=";
  };

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
