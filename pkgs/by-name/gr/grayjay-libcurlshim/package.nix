{
  lib,
  stdenv,
  grayjay,
  curl-impersonateFull,
}:

stdenv.mkDerivation {
  pname = "${grayjay.pname}-libcurlshim";

  # nixpkgs-update: no auto update
  inherit (grayjay) version src;

  sourceRoot = "source/curlbind/native";

  dontConfigure = true;

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;
  buildInputs = [ curl-impersonateFull ];
  buildPhase = ''
    runHook preBuild

    $CC -shared -fPIC \
      -I ${lib.getDev curl-impersonateFull}/include \
      "curlshim.c" \
      -o libcurlshim.so \
      -L ${lib.getLib curl-impersonateFull}/lib -lcurl-impersonate

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp libcurlshim.so $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "curl-impersonate shim used by Grayjay";
    inherit (grayjay.meta)
      homepage
      license
      maintainers
      platforms
      ;
  };
}
