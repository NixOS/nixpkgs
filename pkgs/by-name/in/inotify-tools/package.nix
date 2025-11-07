{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  nix-update-script,
  fanotifySupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "inotify-tools";
  version = "4.25.9.0";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "inotify-tools";
    rev = finalAttrs.version;
    hash = "sha256-u7bnFmSEXNGVZTJ71kOTscQLymbjJblJCIY9Uj7/3mM=";
  };

  configureFlags = [
    (lib.enableFeature fanotifySupport "fanotify")
  ];

  nativeBuildInputs = [ autoreconfHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/inotify-tools/inotify-tools/wiki";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      marcweber
      pSub
      shamilton
    ];
    platforms = platforms.linux;
  };
})
