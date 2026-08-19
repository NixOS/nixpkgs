{
  stdenv,
  grayjay,
  curl-impersonateFull,
}:

stdenv.mkDerivation {
  pname = "${grayjay.pname}-libcurlshim";

  # nixpkgs-update: no auto update
  inherit (grayjay) version src;

  sourceRoot = "${grayjay.src.name}/curlbind/native";

  dontConfigure = true;

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;
  buildInputs = [ curl-impersonateFull ];

  buildPhase = ''
    runHook preBuild

    $CC -shared -fPIC -lcurl-impersonate "curlshim.c" -o libcurlshim.so

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 libcurlshim.so -t "$out/lib/"

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
