{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  python3,
}:

let
  platform =
    {
      aarch64-linux = "armlinux64";
      x86_64-linux = "linux64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "gurobi";
  version = "13.0.1";

  src = fetchurl {
    url = "https://packages.gurobi.com/${lib.versions.majorMinor version}/gurobi${version}_${platform}.tar.gz";
    hash =
      {
        aarch64-linux = "sha256-MQDqu95e+fJ00FGtYVw2FlkZ6uhl5eTFefpsA0ti+jI=";
        x86_64-linux = "sha256-7GIyF6xfoGV3madS7XwCshQfu5wP80Ep1uH4yaj+Ttg=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  sourceRoot = "gurobi${builtins.replaceStrings [ "." ] [ "" ] version}/${platform}";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    (python3.withPackages (ps: [
      ps.gurobipy
    ]))
  ];

  strictDeps = true;

  makeFlags = [ "--directory=src/build" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/* $out/bin/

    mkdir -p $out/include
    cp include/gurobi*.h $out/include/

    mkdir -p $out/lib
    cp lib/*.jar $out/lib/
    cp lib/libGurobiJni*.so $out/lib/
    cp lib/libgurobi*.so* $out/lib/
    cp lib/libgurobi*.a $out/lib/
    cp src/build/*.a $out/lib/

    mkdir -p $out/share/java
    ln -s $out/lib/gurobi.jar $out/share/java/
    ln -s $out/lib/gurobi-javadoc.jar $out/share/java/

    runHook postInstall
  '';

  passthru.libSuffix = lib.replaceStrings [ "." ] [ "" ] (lib.versions.majorMinor version);

  meta = {
    description = "Optimization solver for mathematical programming";
    homepage = "https://www.gurobi.com";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.unfree;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ wegank ];
  };
}
