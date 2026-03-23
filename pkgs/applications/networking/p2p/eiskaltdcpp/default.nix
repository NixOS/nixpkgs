{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  bzip2,
  libX11,
  mkDerivation,
  qtbase,
  qttools,
  qtmultimedia,
  qtscript,
  libiconv,
  pcre-cpp,
  libidn,
  lua5,
  miniupnpc,
  aspell,
  gettext,
  perl,
}:

mkDerivation rec {
  pname = "eiskaltdcpp";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "eiskaltdcpp";
    repo = "eiskaltdcpp";
    rev = "v${version}";
    sha256 = "sha256-JmAopXFS6MkxW0wDQ1bC/ibRmWgOpzU0971hcqAehLU=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/5ab5e1137a46864b6ecd1ca302756da8b833f754.patch?full_index=1";
      hash = "sha256-GIdcIHKXNSbHxbiMGRPgfq2w/zNSfR/FhyyXayFWfg8=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    qtbase
    qttools
    qtmultimedia
    qtscript
    bzip2
    libX11
    pcre-cpp
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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.6.3)" "cmake_minimum_required (VERSION 3.10)"
    substituteInPlace {dcpp,dht,extra,}json/CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.6)" "cmake_minimum_required (VERSION 3.10)"
    substituteInPlace eiskaltdcpp-{cli,daemon}/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required (VERSION 3.10)"
    substituteInPlace eiskaltdcpp-qt/CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8.11)" "cmake_minimum_required (VERSION 3.10)"
  '';

  cmakeFlags = [
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
