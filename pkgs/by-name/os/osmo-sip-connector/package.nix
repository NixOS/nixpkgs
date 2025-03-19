{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libosmocore,
  sofia_sip,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "osmo-sip-connector";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "osmo-sip-connector";
    rev = version;
    hash = "sha256-NmjaN28NnAIpMwUHCUS+7LJBwvCp48kyhmHRf6cU5WE=";
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libosmocore
    sofia_sip
    glib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "This implements an interface between the MNCC (Mobile Network Call Control) interface of OsmoMSC (and also previously OsmoNITB) and SIP";
    mainProgram = "osmo-sip-connector";
    homepage = "https://osmocom.org/projects/osmo-sip-conector";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
}
