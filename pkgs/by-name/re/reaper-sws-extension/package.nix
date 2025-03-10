{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  php,
  perl,
  git,
  pkg-config,
  gtk3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "reaper-sws-extension";
  version = "2.14.0.3";

  src = fetchFromGitHub {
    owner = "reaper-oss";
    repo = "sws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-37pBbNACQuuEk1HJTiUHdb0mDiR2+ZsEQUOhz7mrPPg=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    git
    perl
    php
    pkg-config
  ];

  buildInputs = [ gtk3 ];

  meta = {
    description = "Reaper Plugin Extension";
    longDescription = ''
      The SWS / S&M extension is a collection of features that seamlessly integrate into REAPER, the Digital Audio Workstation (DAW) software by Cockos, Inc.
      It is a collaborative and open source project.
    '';
    homepage = "https://www.sws-extension.org/";
    maintainers = with lib.maintainers; [ pancaek ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
