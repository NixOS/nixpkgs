{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt4, boost, bzip2, libX11
, fetchpatch, libiconv, pcre-cpp, libidn, lua5, miniupnpc, aspell, gettext }:

stdenv.mkDerivation rec {
  name = "eiskaltdcpp-${version}";
  version = "2.2.10";

  src = fetchFromGitHub {
    owner = "eiskaltdcpp";
    repo = "eiskaltdcpp";
    rev = "v${version}";
    sha256 = "1mqz0g69njmlghcra3izarjxbxi1jrhiwn4ww94b8jv8xb9cv682";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ qt4 boost bzip2 libX11 pcre-cpp libidn lua5 miniupnpc aspell gettext ]
    ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  patches = [
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/3b7b56bd7060b426b1f1bfded392ae6853644e2e.patch";
      sha256 = "1rqjdsvirn3ks9w9qn893fb73mz84xm04wl13fvsvj8p42i5cjas";
    })
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/bb9eb364a943fe2a67b3ea52ec6a3f9e911f07dc.patch";
      sha256 = "1hjhf9a9j4z8v24g5qh5mcg3n0540lbn85y7kvxsh3khc5v3cywx";
    })
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/ef4426f1f9a8255e335b0862234e6cc28befef5e.patch";
      sha256 = "13j018c499n4b5as2n39ws64yj0cf4fskxbqab309vmnjkirxv6x";
    })
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/a9c136c8707280d0eeb66be6b289d9718287c55c.patch";
      sha256 = "0w8v4mbrzk7pmzc475ff96mzzwlh8a0p62kk7p829m5yqdwj4sc9";
    })
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/3b9c502ff5c98856d4f8fdb7ed3c6ef34448bfb7.patch";
      sha256 = "0fjwaq0wd9a164k5ysdjy89hx0ixnxc6q7cvyn1ba28snm0pgxb8";
    })
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/3b7b56bd7060b426b1f1bfded392ae6853644e2e.patch";
      sha256 = "1rqjdsvirn3ks9w9qn893fb73mz84xm04wl13fvsvj8p42i5cjas";
    })
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/bb9eb364a943fe2a67b3ea52ec6a3f9e911f07dc.patch";
      sha256 = "1hjhf9a9j4z8v24g5qh5mcg3n0540lbn85y7kvxsh3khc5v3cywx";
    })
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/ef4426f1f9a8255e335b0862234e6cc28befef5e.patch";
      sha256 = "13j018c499n4b5as2n39ws64yj0cf4fskxbqab309vmnjkirxv6x";
    })
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/a9c136c8707280d0eeb66be6b289d9718287c55c.patch";
      sha256 = "0w8v4mbrzk7pmzc475ff96mzzwlh8a0p62kk7p829m5yqdwj4sc9";
    })
    (fetchpatch {
      url = "https://github.com/eiskaltdcpp/eiskaltdcpp/commit/3b9c502ff5c98856d4f8fdb7ed3c6ef34448bfb7.patch";
      sha256 = "0fjwaq0wd9a164k5ysdjy89hx0ixnxc6q7cvyn1ba28snm0pgxb8";
    })
  ];

  cmakeFlags = ''
    -DUSE_ASPELL=ON
    -DUSE_QT_QML=ON
    -DFREE_SPACE_BAR_C=ON
    -DUSE_MINIUPNP=ON
    -DLOCAL_MINIUPNP=ON
    -DDBUS_NOTIFY=ON
    -DUSE_JS=ON
    -DPERL_REGEX=ON
    -DUSE_CLI_XMLRPC=ON
    -DWITH_SOUNDS=ON
    -DLUA_SCRIPT=ON
    -DWITH_LUASCRIPTS=ON
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A cross-platform program that uses the Direct Connect and ADC protocols";
    homepage = https://github.com/eiskaltdcpp/eiskaltdcpp;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
