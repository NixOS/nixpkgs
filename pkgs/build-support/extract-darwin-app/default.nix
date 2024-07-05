{ lib
, stdenv
, makeWrapper
, undmg
}:

/** A function to make a derivation from a darwin bundle
  *
  * It makes the assumption that the bundle passed to src is:
  *  - an archive with a single folder: $appName.app
  *  - a .dmg (pass the isDmg attribute)
  *  - a folder containing a Contents/ folder e.g `src = ./AnApp.app`
  *
  * Information about the bundles can be found:
  * - https://en.wikipedia.org/wiki/Bundle_(macOS)
  * - https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFBundles/BundleTypes/BundleTypes.html#//apple_ref/doc/uid/10000123i-CH101-SW19
  * - https://en.wikipedia.org/wiki/Apple_Disk_Image
  */
{
  /** ${appName}.app */
  appName
, /** Name of the file found in ${appName}.app/Contents/MacOS/${binaryName}
    * to be executed
    * TODO: detect this automatically from the .plist file?
    */
  binaryName
, pname
, version
, /** a nix path or derivation to be used as mkDerivation.src */
  src
, /** The meta attribute passed to mkDerivation */
  packageMeta ? { }
}:
stdenv.mkDerivation
  # .dmg extracts have multiple folders
  # the unpack phase requires only one folder
{
  inherit pname version src;
  nativeBuildInputs = [ makeWrapper undmg ];

  installPhase = ''
    appDir="$out/Applications/${appName}.app"
    binDir="$appDir"/Contents/MacOS

    mkdir -p $out/bin
    if [[ -d Contents/ ]] ; then
      # .dmg uses sourceRoot, which means PWD is already in the sourceRoot
      # Passing a .app folder also means we've already cd'ed into the folder
      mkdir -p $appDir
      cp -r Contents $appDir
    else
      # expects a .app folder in the source folder
      mkdir $out/Applications
      cp -r ${appName}.app/ $appDir
    fi

    # Make application available in bin/
    makeWrapper $binDir/${binaryName} $out/bin/${pname}
  '';

  meta = {
    platforms = lib.platforms.darwin;
    mainProgram = binaryName;
    name = pname;
    hydraPlatforms = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  } // packageMeta;
}
