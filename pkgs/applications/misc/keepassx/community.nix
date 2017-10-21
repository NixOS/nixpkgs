{ stdenv, fetchFromGitHub, fetchpatch,
  cmake, libgcrypt, zlib, libmicrohttpd, libXtst, qtbase, qttools, libgpgerror, glibcLocales, libyubikey, yubikey-personalization, libXi, qtx11extras
, withKeePassHTTP ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "keepassx-community-${version}";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = "${version}";
    sha256 = "1g9qz81i7rsfywl03bwl3cg7q91vp24519b91y5liiyrqrq0zx94";
  };

  cmakeFlags = [ 
    "-DWITH_GUI_TESTS=ON" 
    "-DWITH_XC_AUTOTYPE=ON"
    "-DWITH_XC_YUBIKEY=ON"
  ] ++ (optional withKeePassHTTP "-DWITH_XC_HTTP=ON");

  doCheck = true;
  checkPhase = ''
    export LC_ALL="en_US.UTF-8"
    make test ARGS+="-E testgui --output-on-failure"
  '';

  buildInputs = [ cmake libgcrypt zlib qtbase qttools libXtst libmicrohttpd libgpgerror glibcLocales libyubikey yubikey-personalization libXi qtx11extras ];

  meta = {
    description = "Fork of the keepassX password-manager with additional http-interface to allow browser-integration an use with plugins such as PasslFox (https://github.com/pfn/passifox). See also keepassX2.";
    homepage = https://github.com/keepassxreboot/keepassxc;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ s1lvester jonafato ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
