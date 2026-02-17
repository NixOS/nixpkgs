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

stdenv.mkDerivation (finalAttrs: {
  pname = "sirikali";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "mhogomchungu";
    repo = "sirikali";
    rev = finalAttrs.version;
    hash = "sha256-OaZrgX6zxp1ZP72xiBl0+h0nAQb1Z1eiqaSYdtxsDzQ=";
  };

  buildInputs = [
    qt6.qtbase
    libpwquality
    hicolor-icon-theme
    libgcrypt
  ]
  ++ lib.optionals withKWallet [ kdePackages.kwallet ]
  ++ lib.optionals withLibsecret [ libsecret ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
    pkg-config
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        cryfs
        encfs
        fscrypt-experimental
        gocryptfs
        securefs
        sshfs
      ]
    }"
  ];

  doCheck = true;

  cmakeFlags = [
    "-DINTERNAL_LXQT_WALLET=false"
    "-DNOKDESUPPORT=${if withKWallet then "false" else "true"}"
    "-DNOSECRETSUPPORT=${if withLibsecret then "false" else "true"}"
    "-DBUILD_WITH_QT6=true"
  ];

  meta = {
    description = "Qt/C++ GUI front end to sshfs, ecryptfs-simple, cryfs, gocryptfs, securefs, fscrypt and encfs";
    homepage = "https://github.com/mhogomchungu/sirikali";
    changelog = "https://github.com/mhogomchungu/sirikali/blob/${finalAttrs.src.rev}/changelog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ linuxissuper ];
    mainProgram = "sirikali";
    platforms = lib.platforms.all;
  };
})
