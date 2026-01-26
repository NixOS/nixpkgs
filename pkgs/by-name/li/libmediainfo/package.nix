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

stdenv.mkDerivation (finalAttrs: {
  pname = "libmediainfo";
  version = "25.10";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/libmediainfo/${finalAttrs.version}/libmediainfo_${finalAttrs.version}.tar.xz";
    hash = "sha256-rRPZeXsEbOOdDGWm+B0q7yQpc0whhlpqTFksfAHySd0=";
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

  meta = {
    description = "Shared library for mediainfo";
    homepage = "https://mediaarea.net/";
    changelog = "https://mediaarea.net/MediaInfo/ChangeLog";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.devhell ];
  };
})
