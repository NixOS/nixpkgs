{
  lib,
  stdenv,
  makeWrapper,
  undmg,
}:

/** A function to make a derivation from a darwin binary
  *
  * It makes the assumption that the binary comes in a ".app" or ".dmg".
  *
  * Information about the bundles can be found:
  * - https://en.wikipedia.org/wiki/Bundle_(macOS)
  * - https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/BundleTypes/BundleTypes.html#//apple_ref/doc/uid/10000123i-CH101-SW19
  * - https://en.wikipedia.org/wiki/Apple_Disk_Image
  */
{
  /** ${appName}.app */
  appName,
  /** Name of the file found in ${appName}.app/Contents/MacOS/${binaryName}
    * to be executed
    * TODO: detect this automatically from the .plist file?
    */
  binaryName,
  pname,
  version,
  /** a nix path or derivation to be used as mkDerivation.src */
  src,
  /** is src a .dmg .
    * These contain multiple folders after extraction
    * which requires special treatment in the unpackPhase
    * TODO: Detect this automatically someday
    */
  isDmg ? false,
  /** Whether to use makeWrapper for the binary.
    * For some packages symbolic links just don't work
    */
  wrapBinary ? false,
  /** The meta attribute passed to mkDerivation */
  packageMeta ? {},
  /** Can use a custom function e.g stdenvNoCC.mkDerivation */
  derivationFunction ? stdenv.mkDerivation,
}:
derivationFunction (
    # .dmg extracts have multiple folders
    # the unpack phase requires only one folder
    (lib.attrsets.optionalAttrs isDmg {
      sourceRoot = "${appName}.app";
    }) // {
    inherit pname version src;
    nativeBuildInputs = (lib.optional wrapBinary makeWrapper) ++ (lib.optional isDmg undmg) ;

    installPhase = ''
    appDir="$out/Applications/${appName}.app"
    binDir="$appDir"/Contents/MacOS

    mkdir -p $out/bin
    if [[ "${toString isDmg}" = "1" ]] ; then
      # .dmg uses sourceRoot, which means PWD is already in the sourceRoot
      mkdir -p $appDir
      cp -r Contents $appDir
    else
      # expects a .app folder in the source folder
      mkdir $out/Applications
      cp -r ${appName}.app/ $appDir
    fi

    # Make application available in bin/
    if [[ "${toString wrapBinary}" = "1" ]] ; then
      makeWrapper $binDir/${binaryName} $out/bin/${pname}
    else
      ln -s $binDir/${binaryName} $out/bin
    fi
    '';

    meta = {
      platforms = lib.platforms.darwin;
      mainProgram = binaryName;
      name = pname;
      hydraPlatforms = [];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    } // packageMeta;

   }
)
