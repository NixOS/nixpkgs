{
  lib,
  stdenv,
  fetchurl,
  unzip,
  file,
  licenseFile ? null,
  optgamsFile ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "54.7.0";
  pname = "gams";
  src = fetchurl {
    url = "https://d37drm4t2jghv5.cloudfront.net/distributions/${finalAttrs.version}/linux/linux_x64_64_sfx.exe";
    hash = "sha256-nLt8EdoLzlGCXD5nmFuxSSFKekFcjELCxjmgkZobS9I=";
  };
  unpackCmd = "unzip $src";
  nativeBuildInputs = [ unzip ];
  buildInputs = [ file ];
  dontBuild = true;

  installPhase =
    assert licenseFile != null;
    ''
      mkdir -p "$out/bin" "$out/share/gams"
      cp -a * "$out/share/gams"

      cp ${licenseFile} $out/share/gams/gamslice.txt
    ''
    + lib.optionalString (optgamsFile != null) ''
      cp ${optgamsFile} $out/share/gams/optgams.def
      ln -s $out/share/gams/optgams.def $out/bin/optgams.def
    '';

  postFixup = ''
    for f in $out/share/gams/*; do
      if [[ -x $f ]] && [[ -f $f ]] && [[ ! $f =~ .*\.so$ ]]; then
        if patchelf \
          --set-rpath "$out/share/gams" \
          --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $f; then
          ln -s $f $out/bin/$(basename $f)
        fi
      fi
    done
  '';

  meta = {
    description = "General Algebraic Modeling System";
    longDescription = ''
      The General Algebraic Modeling System is a high-level modeling system for mathematical optimization.
      GAMS is designed for modeling and solving linear, nonlinear, and mixed-integer optimization problems.
    '';
    homepage = "https://www.gams.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.Scriptkiddi ];
    platforms = lib.platforms.linux;
  };
})
