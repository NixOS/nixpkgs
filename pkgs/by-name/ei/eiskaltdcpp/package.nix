{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  bzip2,
  libx11,
  libsForQt5,
  libiconv,
  pcre2,
  libidn2,
  libidn,
  lua5,
  miniupnpc,
  aspell,
  gettext,
  perl,
}:

stdenv.mkDerivation {
  pname = "eiskaltdcpp";
  version = "2.4.2-unstable-2024-11-25";

  src = fetchFromGitHub {
    owner = "eiskaltdcpp";
    repo = "eiskaltdcpp";
    rev = "697db4b03e3d9ffa48b3d4c74fd043dee7663266";
    hash = "sha256-6ExzvfBzV/iVMjdObW76usexm9MW5xwyvTisAFPLQ6Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.qtmultimedia
    libsForQt5.qtscript
    bzip2
    libx11
    pcre2
    libidn2
    libidn
    lua5
    miniupnpc
    aspell
    gettext
    (perl.withPackages (
      p: with p; [
        GetoptLong
        TermShellUI
      ]
    ))
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    (lib.cmakeBool "DBUS_NOTIFY" true)
    (lib.cmakeBool "FREE_SPACE_BAR_C" true)
    (lib.cmakeBool "LUA_SCRIPT" true)
    (lib.cmakeBool "PERL_REGEX" true)
    (lib.cmakeBool "USE_ASPELL" true)
    (lib.cmakeBool "USE_CLI_JSONRPC" true)
    (lib.cmakeBool "USE_MINIUPNP" true)
    (lib.cmakeBool "USE_JS" true)
    (lib.cmakeBool "WITH_LUASCRIPTS" true)
    (lib.cmakeBool "WITH_SOUNDS" true)
  ];

  postInstall = ''
    ln -s $out/bin/$pname-qt $out/bin/$pname
  '';

  preFixup = ''
    substituteInPlace $out/bin/eiskaltdcpp-cli-jsonrpc \
      --replace "/usr/local" "$out"
  '';

  meta = {
    description = "Cross-platform program that uses the Direct Connect and ADC protocols";
    homepage = "https://github.com/eiskaltdcpp/eiskaltdcpp";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
