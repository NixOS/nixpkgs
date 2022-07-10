{ callPackage
, config
, lib
, cudaPackages
, cudaSupport ? config.cudaSupport or false
, lang ? "en"
, version ? null
}:

let versions = callPackage ./versions.nix { };

    matching-versions =
      lib.sort (v1: v2: lib.versionAtLeast v1.version v2.version) (lib.filter
        (v: v.lang == lang
            && (if version == null then true else isMatching v.version version))
        versions);

    found-version =
      if matching-versions == []
      then throw ("No registered Mathematica version found to match"
                  + " version=${version} and language=${lang}")
      else lib.head matching-versions;

    specific-drv = ./. + "/(lib.versions.major found-version.version).nix";

    real-drv = if lib.pathExists specific-drv
               then specific-drv
               else ./generic.nix;

    isMatching = v1: v2:
      let as      = lib.splitVersion v1;
          bs      = lib.splitVersion v2;
          n       = lib.min (lib.length as) (lib.length bs);
          sublist = l: lib.sublist 0 n l;
      in lib.compareLists lib.compare (sublist as) (sublist bs) == 0;

in

callPackage real-drv {
  inherit cudaSupport cudaPackages;
  inherit (found-version) version lang src;
  name = ("mathematica"
          + lib.optionalString cudaSupport "-cuda"
          + "-${found-version.version}"
          + lib.optionalString (lang != "en") "-${lang}");
  meta = with lib; {
    description = "Wolfram Mathematica computational software system";
    homepage = "http://www.wolfram.com/mathematica/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ herberteuler ];
    platforms = [ "x86_64-linux" ];
  };
}
