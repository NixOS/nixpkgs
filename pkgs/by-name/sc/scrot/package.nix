{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  autoreconfHook,
  autoconf-archive,
  libx11,
  libxext,
  libxfixes,
  libxcomposite,
  libxrandr,
  pkg-config,
  libbsd,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scrot";
  version = "2.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "scrot";
    tag = finalAttrs.version;
    hash = "sha256-sxvopl04sMHyI3v2SH5O+QnlMneWThJKgFzYIe7t/58=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    imlib2
    libx11
    libxext
    libxfixes
    libxcomposite
    libxrandr
    libbsd
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "Command-line screen capture utility";
    mainProgram = "scrot";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    license = lib.licenses.mitAdvertising;
  };
})
