{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  pkg-config,
  gnutls,
  libgcrypt,
  libpar2,
  libcap,
  libsigcxx,
  libxml2,
  ncurses,
  openssl,
  zlib,
  deterministic-uname,
  nixosTests,
}:

let
  par2TurboSrc = fetchFromGitHub {
    owner = "nzbgetcom";
    repo = "par2cmdline-turbo";
    rev = "v1.4.0-20260323"; # from cmake/par2-turbo.cmake
    hash = "sha256-oeQY7GJkaEmxEqJALpjAPFpfq+YsNWv4VajotE25xCI=";
  };
  rapidyencSrc = fetchFromGitHub {
    owner = "nzbgetcom";
    repo = "rapidyenc";
    rev = "v1.1.1-20260217"; # from cmake/rapidyenc.cmake
    hash = "sha256-1K0LrB1AhacYS/54eCn+vQFAwP6IUVUrPCqFopojXDE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nzbget";
  version = "26.2";

  src = fetchFromGitHub {
    owner = "nzbgetcom";
    repo = "nzbget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0HNTEpaXD9tpMNsJ5UPPwW/XO2TX0IwibskSjpjvxHw=";
  };

  patches = [
    # remove git usage for fetching modified+vendored par2cmdline-turbo and rapidyenc
    ./remove-git-usage.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    gnutls
    libgcrypt
    libpar2
    libcap
    libsigcxx
    libxml2
    ncurses
    openssl
    zlib
  ];

  postPatch = ''
    substituteInPlace cmake/par2-turbo.cmake \
      --subst-var-by 'par2_turbo_src' '${par2TurboSrc}' \

    substituteInPlace cmake/rapidyenc.cmake \
      --subst-var-by 'rapidyenc_src' '${rapidyencSrc}'

    substituteInPlace daemon/util/Util.cpp \
      --replace-fail "std::string(\"uname \")" "std::string(\"${lib.getExe deterministic-uname} \")"
  '';

  postInstall = ''
    install -Dm444 nzbget.conf $out/share/nzbget/nzbget.conf
  '';

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) nzbget; };

  meta = {
    homepage = "https://nzbget.com/";
    changelog = "https://github.com/nzbgetcom/nzbget/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    description = "Command line tool for downloading files from news servers";
    maintainers = with lib.maintainers; [
      pSub
      devusb
    ];
    platforms = with lib.platforms; unix;
    mainProgram = "nzbget";
  };
})
