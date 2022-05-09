{ callPackage
, lib
, cudaPackages
, cudaSupport ? false
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
      let f = v: map lib.toInt (lib.versions.splitVersion v.version);
      in lib.compareLists lib.compare (f v1) (f v2) > 0;

    isMatching = v1: v2:
      let n = lib.min (builtins.stringLength v1) (builtins.stringLength v2);
      in builtins.substring 0 n v1 == builtins.substring 0 n v2;

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
