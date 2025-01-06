{ lib, stdenv, buildPackages
, staticBuild ? stdenv.hostPlatform.isStatic
}:

let inherit (buildPackages.buildPackages) gcc; in

stdenv.mkDerivation {
  pname = "libiberty";
  version = "${gcc.cc.version}";

  inherit (gcc.cc) src;

  outputs = [ "out" "dev" ];

  postUnpack = "sourceRoot=\${sourceRoot}/libiberty";

  configureFlags = [ "--enable-install-libiberty" ]
    ++ lib.optional (!staticBuild) "--enable-shared";

  postInstall = lib.optionalString (!staticBuild) ''
    cp pic/libiberty.a $out/lib*/libiberty.a
  '';

  meta = {
    homepage = "https://gcc.gnu.org/";
    license = lib.licenses.lgpl2;
    description = "Collection of subroutines used by various GNU programs";
    maintainers = with lib.maintainers; [ abbradar ericson2314 ];
    platforms = lib.platforms.unix;
  };
}
