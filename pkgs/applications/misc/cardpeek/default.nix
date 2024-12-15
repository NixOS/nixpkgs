{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  glib,
  gtk3,
  pcsclite,
  lua5_2,
  curl,
  readline,
  PCSC,
}:
let
  version = "0.8.4";
in
stdenv.mkDerivation {
  pname = "cardpeek";
  inherit version;

  src = fetchFromGitHub {
    owner = "L1L1";
    repo = "cardpeek";
    rev = "cardpeek-${version}";
    sha256 = "1ighpl7nvcvwnsd6r5h5n9p95kclwrq99hq7bry7s53yr57l6588";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # replace xcode check and hard-coded PCSC framework path
    substituteInPlace configure.ac \
      --replace 'if test ! -e "/Applications/Xcode.app/"; then' 'if test yes != yes; then' \
      --replace 'PCSC_HEADERS=`ls -d /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/*.sdk/System/Library/Frameworks/PCSC.framework/Versions/Current/Headers/ | sort | head -1`' 'PCSC_HEADERS=${PCSC}/Library/Frameworks/PCSC.framework/Headers'
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs =
    [
      glib
      gtk3
      lua5_2
      curl
      readline
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin PCSC
    ++ lib.optional stdenv.hostPlatform.isLinux pcsclite;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/L1L1/cardpeek";
    description = "Tool to read the contents of ISO7816 smart cards";
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ embr ];
    mainProgram = "cardpeek";
  };
}
