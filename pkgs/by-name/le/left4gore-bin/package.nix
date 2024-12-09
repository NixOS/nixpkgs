{ stdenvNoCC, lib, fetchurl, buildFHSEnv }:

let
  version = "2.3";

  # Unwrapped package, for putting into the FHS env
  left4gore-unwrapped = stdenvNoCC.mkDerivation {
    pname = "left4gore-unwrapped";
    inherit version;

    src = fetchurl {
      url = "http://www.left4gore.com/dist/left4gore-${version}-linux.tar.gz";
      sha256 = "1n57nh32ybn6kirn8djh0nsjx6m84c0jfi1x8r4w2qr0qky3z7p0";
    };

    installPhase = ''
      mkdir -p $out/bin
      cp left4gore $out/bin
    '';
  };

  # FHS env, as patchelf will not work
  env = buildFHSEnv {
    pname = "left4gore-env";
    inherit version;
    targetPkgs = _: [ left4gore-unwrapped ];
    runScript = "left4gore";
  };

in stdenvNoCC.mkDerivation {
  pname = "left4gore";
  inherit version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${env}/bin/* $out/bin/left4gore
  '';

  meta = with lib; {
    homepage = "http://www.left4gore.com";
    description = "Memory patcher which adds the gore back into Left 4 Dead 2";
    license = licenses.unfree; # Probably the best choice
    maintainers = with maintainers; [ das_j ];
  };
}
