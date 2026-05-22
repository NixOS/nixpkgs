{
  lib,
  python3,
  python3Packages,
  pkgsBuildTarget,
  minijail,
}:

let
  targetClang = pkgsBuildTarget.targetPackages.clangStdenv.cc;
in

python3Packages.buildPythonApplication {
  pyproject = true;
  pname = "minijail-tools";
  inherit (minijail) version src;

  postPatch = ''
    substituteInPlace Makefile --replace-fail /bin/echo echo
  '';

  build-system = [
    python3Packages.setuptools
  ];

  postConfigure = ''
    substituteInPlace tools/compile_seccomp_policy.py \
        --replace-fail "'constants.json'" "'$out/share/constants.json'"
  '';

  preBuild = ''
    make libconstants.gen.c libsyscalls.gen.c
    ${targetClang}/bin/${targetClang.targetPrefix}cc -S -emit-llvm \
        libconstants.gen.c libsyscalls.gen.c
    ${python3.pythonOnBuildForHost.interpreter} tools/generate_constants_json.py \
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
