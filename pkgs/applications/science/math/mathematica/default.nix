{ callPackage
, lib
, cudaSupport ? false
, cudaPackages ? null
, lang ? "en"
, version ? null
}:

let versions = callPackage ./versions.nix { };

    matching-versions =
      lib.sort compareVersions (lib.filter
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

    compareVersions = v1: v2:
      let a = lib.versions.major v1.version;
          b = lib.versions.major v2.version;
      in lib.toInt a > lib.toInt b;

    isMatching = v1: v2:
      let as = lib.versions.splitVersion v1;
          bs = lib.versions.splitVersion v2;
          n  = lib.min (lib.length as) (lib.length bs);
      in lib.take n as == lib.take n bs;

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
    maintainers = with maintainers; [ herberteuler ];
    platforms = [ "x86_64-linux" ];
  };
}
