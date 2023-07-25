{
  lib,
  stdenv,
  makeWrapper,
  undmg,
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
  /** The unpackPhase fails with many subfolders!
    * Also set this if `src` is a .dmg or another archive
    *  that extracts to a folder containing multiple subfolders.
    * The assumption is made a folder named "$appName.app" exists.
    * Should you know the true name, use the `sourceRoot` option instead.
    */
  srcHasManySubfolders ? false,
  /** See `srcHasManySubfolders` */
  sourceRoot ? null,
  /** Whether to use makeWrapper for the binary.
    * For some packages symbolic links just don't work
    */
  wrapBinary ? false,
  /** The meta attribute passed to mkDerivation */
  packageMeta ? {},
  /** Can use a custom function e.g stdenvNoCC.mkDerivation */
  derivationFunction ? stdenv.mkDerivation,
}:
let
  # Prefer sourceRoot over srcHasManySubfolders (if both are set)
  _sourceRoot = (lib.findFirst ( el: el.condition) { value = null; } [
    { condition = sourceRoot != null; value = sourceRoot ;}
    { condition = srcHasManySubfolders; value = "${appName}.app"; }
  ]).value;
in
derivationFunction (
    # .dmg extracts have multiple folders
    # the unpack phase requires only one folder
    (lib.attrsets.optionalAttrs (lib.isString _sourceRoot) {
      sourceRoot = _sourceRoot;
    }) // {
    inherit pname version src;
    nativeBuildInputs = (lib.optional wrapBinary makeWrapper) ++ [ undmg ];

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
