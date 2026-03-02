{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxGTK32,
  subversion,
  apr,
  aprutil,
  python3,
}:

stdenv.mkDerivation {
  pname = "rapidsvn";
  version = "unstable-2021-08-02";

  src = fetchFromGitHub {
    owner = "RapidSVN";
    repo = "RapidSVN";
    rev = "3a564e071c3c792f5d733a9433b9765031f8eed0";
    hash = "sha256-6bQTHAOZAP+06kZDHjDx9VnGm4vrZUDyLHZdTpiyP08=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace "[3.0.*]" "[3.*]"
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    wxGTK32
    subversion
    apr
    aprutil
    python3
  ];

  configureFlags = [
    "--with-svn-include=${subversion.dev}/include"
    "--with-svn-lib=${subversion.out}/lib"
  ];

  env.NIX_CFLAGS_COMPILE = "-std=c++14";

  meta = {
    description = "Multi-platform GUI front-end for the Subversion revision system";
    homepage = "http://rapidsvn.tigris.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "rapidsvn";
  };
}
