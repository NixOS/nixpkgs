{
  lib,
  stdenv,
  fetchurl,
  file,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmodplug";
  version = "0.8.9.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/modplug-xmms/libmodplug/${finalAttrs.version}/libmodplug-${finalAttrs.version}.tar.gz";
    hash = "sha256-5NnLRtp4pjnW6ttP86uVX2jDCZV5tTEK9ks3CR4olX4=";
  };

  postPatch = ''
    substituteInPlace libmodplug.pc.in \
      --replace-fail 'includedir=''${prefix}/include' 'includedir=@includedir@'
  '';

  outputs = [
    "out"
    "dev"
  ];

  preConfigure = ''
    substituteInPlace configure \
       --replace ' -mmacosx-version-min=10.5' "" \
       --replace /usr/bin/file ${file}/bin/file
  '';

  meta = {
    description = "MOD playing library";
    homepage = "https://modplug-xmms.sourceforge.net/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ raskin ];
  };
})
