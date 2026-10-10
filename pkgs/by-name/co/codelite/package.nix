{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  flex,
  gsettings-desktop-schemas,
  gtk3,
  harfbuzz,
  hunspell,
  libssh,
  libedit,
  lldb,
  makeWrapper,
  openssl,
  pcre2,
  pkg-config,
  clang,
  sqlite,
  universal-ctags,
  which,
  wrapGAppsHook3,
  wxwidgets_3_2,
  xterm,
  enableSFTP ? true,
  enableLLDB ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codelite";
  version = "18.5.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eranif";
    repo = "codelite";
    tag = finalAttrs.version;
    hash = "sha256-77pUP/zozo24Tx+yR37FDYI+nzPDW7YXyvR9+4jCSyE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    makeWrapper
    pkg-config
    universal-ctags
    which
    wrapGAppsHook3
    wxwidgets_3_2
  ];

  buildInputs = [
    clang
    gsettings-desktop-schemas
    gtk3
    harfbuzz
    harfbuzz.dev
    hunspell
    libedit
    openssl
    pcre2
    sqlite
    universal-ctags
    wxwidgets_3_2
    xterm
  ]
  ++ lib.optionals enableSFTP [ libssh ]
  ++ lib.optionals enableLLDB [ lldb ];

  preConfigure = ''
    export PATH="${wxwidgets_3_2}/bin:$PATH"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${harfbuzz.dev}/include/harfbuzz"
  '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_SFTP" enableSFTP)
    (lib.cmakeBool "ENABLE_LLDB" enableLLDB)
    (lib.cmakeBool "WITH_PCH" false)
    (lib.cmakeBool "CMAKE_SKIP_INSTALL_RPATH" true)
  ];

  postFixup = ''
    wrapProgram "$out/bin/codelite" \
      --prefix PATH : ${lib.makeBinPath [ xterm ]}
  '';

  meta = {
    description = "Open source, cross platform C/C++/PHP/Node.js/Rust IDE";
    homepage = "https://codelite.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sincorchetes ];
    platforms = lib.platforms.linux;
    mainProgram = "codelite";
  };
})
