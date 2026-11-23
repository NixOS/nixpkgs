{
  lib,
  stdenv,
  fetchurl,
  unzip,
  libccp4,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mosflm";
  version = "7.4.0";

  src =
    if stdenv.hostPlatform.isDarwin then
      fetchurl {
        url = "https://www.mrc-lmb.cam.ac.uk/harry/imosflm/ver${
          builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version
        }/downloads/imosflm-${finalAttrs.version}-osx-64.zip";
        hash = "sha256-+FxiBmIj7Uzed0lGIkPQdiDfefTnM+ZALaZyASydYP8=";
      }
    else
      fetchurl {
        url = "https://www.mrc-lmb.cam.ac.uk/harry/imosflm/ver${
          builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version
        }/downloads/imosflm-${finalAttrs.version}-linux-64.zip";
        hash = "sha256-2we0K09W31LKgn9SHLGti50EA/zhbX+CWWuQGCSKW18=";
      };

  dontBuild = true;

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  # mosflm statically links against its own libccp4, which as the syminfo.lib environment variable problem.
  # Here, we circumvent it by creating a little wrapper script that calls mosflm after setting the SYMINFO variable.
  installPhase = ''
    mkdir -p $out/bin
    cp bin/mosflm $out/bin/mosflm-raw
    makeWrapper $out/bin/mosflm-raw $out/bin/mosflm --set SYMINFO ${libccp4}/share/syminfo.lib --add-flags -n
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Program for integrating single crystal diffraction data from area detectors";
    homepage = "https://www.mrc-lmb.cam.ac.uk/mosflm/mosflm/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.darwin ++ [
      "x86_64-linux"
    ];
    # This is the statically-linked, pre-built binary of mosflm. Compiling it ourselves turns out to be very difficult
    # since the build process is very hard-coded for a specific machine, architecture, and libraries.
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
