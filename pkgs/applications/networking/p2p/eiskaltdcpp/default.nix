{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, boost, bzip2, libX11
, mkDerivation, qtbase, qttools, qtmultimedia, qtscript
, libiconv, pcre-cpp, libidn, lua5, miniupnpc, aspell, gettext, perl }:

mkDerivation rec {
  pname = "eiskaltdcpp";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "eiskaltdcpp";
    repo = "eiskaltdcpp";
    rev = "v${version}";
    sha256 = "0ln8dafa8sni3289g30ndv1wr3ij5lz4abcb2qwcabb79zqxl8hy";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ qtbase qttools qtmultimedia qtscript boost bzip2 libX11 pcre-cpp libidn lua5 miniupnpc aspell gettext
    (perl.withPackages (p: with p; [
      GetoptLong
      RpcXML
      TermShellUI
    ])) ]
    ++ lib.optional stdenv.isDarwin libiconv;

  cmakeFlags = [
    "-DUSE_ASPELL=ON"
    "-DFREE_SPACE_BAR_C=ON"
    "-DUSE_MINIUPNP=ON"
    "-DLOCAL_MINIUPNP=ON"
    "-DDBUS_NOTIFY=ON"
    "-DUSE_JS=ON"
    "-DPERL_REGEX=ON"
    "-DUSE_CLI_XMLRPC=ON"
    "-DWITH_SOUNDS=ON"
    "-DLUA_SCRIPT=ON"
    "-DWITH_LUASCRIPTS=ON"
  ];

  preFixup = ''
    substituteInPlace $out/bin/eiskaltdcpp-cli-xmlrpc \
      --replace "/usr/local" "$out"
  '';

  meta = with lib; {
    description = "A cross-platform program that uses the Direct Connect and ADC protocols";
    homepage = "https://github.com/eiskaltdcpp/eiskaltdcpp";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
