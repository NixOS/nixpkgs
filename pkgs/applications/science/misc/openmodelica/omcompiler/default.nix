{
  stdenv,
  lib,
  gfortran,
  flex,
  bison,
  jre8,
  blas,
  lapack,
  curl,
  readline,
  expat,
  pkg-config,
  buildPackages,
  targetPackages,
  libffi,
  binutils,
  mkOpenModelicaDerivation,
}:
let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
  nativeOMCompiler = buildPackages.openmodelica.omcompiler;
in
mkOpenModelicaDerivation (
  {
    pname = "omcompiler";
    omtarget = "omc";
    omdir = "OMCompiler";
    omdeps = [ ];
    omautoconf = true;

    nativeBuildInputs = [
      jre8
      gfortran
      flex
      bison
      pkg-config
    ] ++ lib.optional isCross nativeOMCompiler;

    buildInputs = [
      targetPackages.stdenv.cc.cc
      blas
      lapack
      curl
      readline
      expat
      libffi
      binutils
    ];

    postPatch = ''
      sed -i -e '/^\s*AR=ar$/ s/ar/${stdenv.cc.targetPrefix}ar/
                 /^\s*ar / s/ar /${stdenv.cc.targetPrefix}ar /
                 /^\s*ranlib/ s/ranlib /${stdenv.cc.targetPrefix}ranlib /' \
          $(find ./OMCompiler -name 'Makefile*')
    '';

    env.CFLAGS = toString [
      "-Wno-error=dynamic-exception-spec"
      "-Wno-error=implicit-function-declaration"
    ];

    preFixup = ''
      for entry in $(find $out -name libipopt.so); do
        patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$entry"
        patchelf --set-rpath '$ORIGIN':"$(patchelf --print-rpath $entry)" "$entry"
      done
    '';

    meta = with lib; {
      description = "Modelica compiler from OpenModelica suite";
      homepage = "https://openmodelica.org";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [
        balodja
        smironov
      ];
      platforms = platforms.linux;
    };
  }
  // lib.optionalAttrs isCross {
    configureFlags = [ "--with-omc=${nativeOMCompiler}/bin/omc" ];
  }
)
