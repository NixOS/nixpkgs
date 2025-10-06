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
    rev = "v1.3.0-20250808"; # from cmake/par2-turbo.cmake
    hash = "sha256-ZP8AI5htmEcxQQtvgShcQ8qNoRL+jBR1BdKS6yyuB/E=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nzbget";
  version = "25.3";

  src = fetchFromGitHub {
    owner = "nzbgetcom";
    repo = "nzbget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ecTz+axqPOlRe0wi7IRiESn2JjLbalI+sQVKqrvrAoU=";
  };

  patches = [
    # remove git usage for fetching modified+vendored par2cmdline-turbo
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

  preConfigure = ''
    mkdir -p build/par2-turbo/src
    cp -r ${par2TurboSrc} build/par2-turbo/src/par2-turbo
    chmod -R u+w build/par2-turbo/src/par2-turbo
  '';

  postPatch = ''
    substituteInPlace daemon/util/Util.cpp \
      --replace-fail "std::string(\"uname \")" "std::string(\"${lib.getExe deterministic-uname} \")"
  '';

  postInstall = ''
    install -Dm444 nzbget.conf $out/share/nzbget/nzbget.conf
  '';

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) nzbget; };

  meta = with lib; {
    homepage = "https://nzbget.com/";
    changelog = "https://github.com/nzbgetcom/nzbget/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl2Plus;
    description = "Command line tool for downloading files from news servers";
    maintainers = with maintainers; [
      pSub
      devusb
    ];
    platforms = with platforms; unix;
    mainProgram = "nzbget";
  };
})
