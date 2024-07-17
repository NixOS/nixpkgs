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
  ] ++ lib.optional stdenv.isDarwin libiconv;

  cmakeFlags = [
    "-DDBUS_NOTIFY=ON"
    "-DFREE_SPACE_BAR_C=ON"
    "-DLUA_SCRIPT=ON"
    "-DPERL_REGEX=ON"
    "-DUSE_ASPELL=ON"
    "-DUSE_CLI_JSONRPC=ON"
    "-DUSE_MINIUPNP=ON"
    "-DUSE_JS=ON"
    "-DWITH_LUASCRIPTS=ON"
    "-DWITH_SOUNDS=ON"
  ];

  postInstall = ''
    ln -s $out/bin/$pname-qt $out/bin/$pname
  '';

  preFixup = ''
    substituteInPlace $out/bin/eiskaltdcpp-cli-jsonrpc \
      --replace "/usr/local" "$out"
  '';

  meta = with lib; {
    description = "Cross-platform program that uses the Direct Connect and ADC protocols";
    homepage = "https://github.com/eiskaltdcpp/eiskaltdcpp";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
