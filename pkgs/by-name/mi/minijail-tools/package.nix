{
  lib,
  python3Packages,
  pkgsBuildTarget,
  pkgsBuildHost,
  minijail,
}:

let
  targetClang = pkgsBuildTarget.targetPackages.clangStdenv.cc;
in

python3Packages.buildPythonApplication {
  format = "setuptools";
  pname = "minijail-tools";
  inherit (minijail) version src;

  postPatch = ''
    substituteInPlace Makefile --replace /bin/echo echo
  '';

  postConfigure = ''
    substituteInPlace tools/compile_seccomp_policy.py \
        --replace "'constants.json'" "'$out/share/constants.json'"
  '';

  preBuild = ''
    make libconstants.gen.c libsyscalls.gen.c
    ${targetClang}/bin/${targetClang.targetPrefix}cc -S -emit-llvm \
        libconstants.gen.c libsyscalls.gen.c
    ${pkgsBuildHost.python3.interpreter} tools/generate_constants_json.py \
        --output constants.json \
        libconstants.gen.ll libsyscalls.gen.ll
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -v constants.json $out/share/constants.json
  '';

  meta = {
    homepage = "https://android.googlesource.com/platform/external/minijail/+/refs/heads/master/tools/";
    description = "Set of tools for minijail";
    license = lib.licenses.asl20;
    inherit (minijail.meta) maintainers platforms;
  };
}
