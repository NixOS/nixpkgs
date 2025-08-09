{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "igmpproxy";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "pali";
    repo = "igmpproxy";
    rev = version;
    sha256 = "sha256-kv8XtZ/z8zPHYSZ4k4arn2Y+L2xegr2DwhvlguJV820=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Daemon that routes multicast using IGMP forwarding";
    homepage = "https://github.com/pali/igmpproxy/";
    changelog = "https://github.com/pali/igmpproxy/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sdier ];
    # The maintainer is using this on linux, but if you test it on other platforms
    # please add them here!
    platforms = lib.platforms.linux;
    mainProgram = "igmpproxy";
  };
}
