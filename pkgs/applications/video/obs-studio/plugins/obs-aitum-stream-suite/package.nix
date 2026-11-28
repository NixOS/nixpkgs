{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  obs-studio,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-aitum-stream-suite";
  version = "1.2.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Aitum";
    repo = "obs-aitum-stream-suite";
    tag = finalAttrs.version;
    hash = "sha256-d+fOj3LGKRlqK3gGZ8qrdVl3uaIC3ViGedUfs7VlsFQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    curl
    obs-studio
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_OUT_OF_TREE" true)
  ];

  postInstall = ''
    rm -rf $out/data
    rm -rf $out/obs-plugins
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Aitum Stream Suite plugin for OBS Studio";
    homepage = "https://github.com/Aitum/obs-aitum-stream-suite";
    maintainers = with lib.maintainers; [
      flexiondotorg
      jonhermansen
      mistyttm
    ];
    license = lib.licenses.gpl2Plus;
    inherit (obs-studio.meta) platforms;
  };
})
