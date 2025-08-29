{
  lib,
  stdenv,
  buildPackages,
  staticBuild ? stdenv.hostPlatform.isStatic,
}:

let
  inherit (buildPackages.buildPackages) gcc;
in

stdenv.mkDerivation {
  pname = "libiberty";
  version = "${gcc.cc.version}";

  inherit (gcc.cc) src;

  outputs = [
    "out"
    "dev"
  ];

  postUnpack = "sourceRoot=\${sourceRoot}/libiberty";

  # needed until config scripts are updated to not use /usr/bin/uname on FreeBSD native
  # updateAutotoolsGnuConfigScriptsHook doesn't seem to work here
  postPatch = ''
    substituteInPlace ../config.guess --replace-fail /usr/bin/uname uname
  '';

  configureFlags = [ "--enable-install-libiberty" ] ++ lib.optional (!staticBuild) "--enable-shared";

  postInstall = lib.optionalString (!staticBuild) ''
    cp pic/libiberty.a $out/lib*/libiberty.a
  '';

  meta = with lib; {
    homepage = "https://gcc.gnu.org/";
    license = licenses.lgpl2;
    description = "Collection of subroutines used by various GNU programs";
    maintainers = with maintainers; [
      ericson2314
    ];
    platforms = platforms.unix;
  };
}
