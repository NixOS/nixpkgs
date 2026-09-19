{
  src,
  version,

  buildNpmPackage,
}:

buildNpmPackage {
  pname = "bitburner-electron";
  inherit version;

  src = src + "/electron";
  npmDepsHash = "sha256-esWF/kNXcs2BVXsHvlnQRv9CACf+/UBs79A03EV7Zps=";

  dontNpmBuild = true;

  installPhase = ''
    mkdir $out
    cp -r . $out
  '';
}
