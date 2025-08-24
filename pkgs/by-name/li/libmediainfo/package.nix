{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libzen,
  zlib,

  # Whether to enable resolving URLs via libcurl
  curlSupport ? true,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "libmediainfo";
  version = "25.07.1";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    hash = "sha256-jm6S8gzyynzoq6U60LWJqJovp9/T55cdOFAQms1JvtU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ zlib ] ++ lib.optionals curlSupport [ curl ];
  propagatedBuildInputs = [ libzen ];

  sourceRoot = "MediaInfoLib/Project/GNU/Library";

  postPatch = lib.optionalString (stdenv.cc.targetPrefix != "") ''
    substituteInPlace configure.ac \
      --replace "pkg-config " "${stdenv.cc.targetPrefix}pkg-config "
  '';

  configureFlags = [
    "--enable-shared"
  ]
  ++ lib.optionals curlSupport [
    "--with-libcurl"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = with lib; {
    description = "Shared library for mediainfo";
    homepage = "https://mediaarea.net/";
    changelog = "https://mediaarea.net/MediaInfo/ChangeLog";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
