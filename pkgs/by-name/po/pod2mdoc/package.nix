{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pod2mdoc";
  version = "0.2";

  src = fetchurl {
    url = "http://mdocml.bsd.lv/pod2mdoc/snapshots/pod2mdoc-${finalAttrs.version}.tgz";
    hash = "sha256-dPH+MfYdyHauClcD7N1zwjw4EPdtt9uQGCUh9OomsPw=";
  };

  # use compat_ohash instead of system ohash, which is BSD-specific
  postPatch = ''
    substituteInPlace Makefile --replace-fail "-DHAVE_OHASH=1" "-DHAVE_OHASH=0"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    install -m 0755 pod2mdoc $out/bin
    install -m 0444 pod2mdoc.1 $out/share/man/man1
  '';

  enableParallelBuild = true;

  meta = {
    homepage = "https://mandoc.bsd.lv/pod2mdoc/";
    description = "Converter from POD into mdoc";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ramkromberg ];
    mainProgram = "pod2mdoc";
  };
})
