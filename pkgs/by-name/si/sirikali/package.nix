{
  lib,
  stdenv,
  libpwquality,
  hicolor-icon-theme,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  kdePackages,
  cryfs,
  encfs,
  fscrypt-experimental,
  gocryptfs,
  securefs,
  sshfs,
  libgcrypt,
  libsecret,
  withKWallet ? true,
  withLibsecret ? true,
}:

stdenv.mkDerivation rec {
  pname = "sirikali";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "sirikali";
    rev = version;
    hash = "sha256-org8mYKwZDdOvkQyd3eD+GaI0aHshMbe2f9i1bM+lBk=";
  };

  buildInputs = [
    qt6.qtbase
    libpwquality
    hicolor-icon-theme
    libgcrypt
  ] ++ lib.optionals withKWallet [ kdePackages.kwallet ] ++ lib.optionals withLibsecret [ libsecret ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
    pkg-config
  ];

  qtWrapperArgs = [
    ''--prefix PATH : ${
      lib.makeBinPath [
        cryfs
        encfs
        fscrypt-experimental
        gocryptfs
        securefs
        sshfs
      ]
    }''
  ];

  doCheck = true;

  cmakeFlags = [
    "-DINTERNAL_LXQT_WALLET=false"
    "-DNOKDESUPPORT=${if withKWallet then "false" else "true"}"
    "-DNOSECRETSUPPORT=${if withLibsecret then "false" else "true"}"
    "-DBUILD_WITH_QT6=true"
  ];

  meta = with lib; {
    description = "Qt/C++ GUI front end to sshfs, ecryptfs-simple, cryfs, gocryptfs, securefs, fscrypt and encfs";
    homepage = "https://github.com/mhogomchungu/sirikali";
    changelog = "https://github.com/mhogomchungu/sirikali/blob/${src.rev}/changelog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linuxissuper ];
    mainProgram = "sirikali";
    platforms = platforms.all;
  };
}
