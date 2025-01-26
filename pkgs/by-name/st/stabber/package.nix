{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  glib,
  expat,
  libmicrohttpd,
  darwin,
}:
stdenv.mkDerivation {
  pname = "stabber-unstable";
  version = "2020-06-08";

  src = fetchFromGitHub {
    owner = "boothj5";
    repo = "stabber";
    rev = "3e5c2200715666aad403d0076e8ab584b329965e";
    sha256 = "0042nbgagl4gcxa5fj7bikjdi1gbk0jwyqnzc5lswpb0l5y0i1ql";
  };

  postPatch = ''
    # New toolchainsd like gcc-13 trigger warnings and fail the build.
    substituteInPlace configure.ac --replace "-Werror" ""
  '';

  preAutoreconf = ''
    mkdir m4
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    glib
    expat
    libmicrohttpd
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Stubbed XMPP Server";
    mainProgram = "stabber";
    homepage = "https://github.com/profanity-im/stabber";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ hschaeidt ];
  };
}
