{
  lib,
  fetchurl,
  gcc13Stdenv,
  gpm,
  libX11,
}:

gcc13Stdenv.mkDerivation (finalAttrs: {
  pname = "beye";
  version = "6.1.0";

  src = fetchurl {
    url =
      let
        versionNoDots = lib.replaceStrings [ "." ] [ "" ] finalAttrs.version;
      in
      "mirror://sourceforge/beye/biew/${finalAttrs.version}/biew-${versionNoDots}-src.tar.bz2";
    hash = "sha256-LoXwPJCN1uyDJGH7+8eRaaM/TKzPSMj+YMvSn1+wbRc=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  hardeningDisable = [ "format" ];

  buildInputs = [
    gpm
    libX11
  ];

  configureFlags = [
    "--with-x11incdir=${lib.getDev libX11}/include"
    "--with-x11libdir=${lib.getLib libX11}/lib"
  ];

  meta = {
    description = "Binary file vIEWer with built-in disassemblers and editor";
    homepage = "https://sourceforge.net/projects/beye/";
    changelog = "https://sourceforge.net/p/beye/news/";
    license = lib.licenses.gpl2Only;
    mainProgram = "biew";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
