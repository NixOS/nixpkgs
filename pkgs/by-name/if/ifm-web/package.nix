{
  fetchurl,
  stdenv,
  lib,
  php83,
  writeShellScript,
  nixosTests,
}:
let
  version = "4.0.2";
  src = fetchurl {
    url = "https://github.com/misterunknown/ifm/releases/download/v${version}/cdn.ifm.php";
    hash = "sha256-37WbRM6D7JGmd//06zMhxMGIh8ioY8vRUmxX4OHgqBE=";
  };

  serve_script = writeShellScript "ifm-serve" ''
    if [ $# -ne 3 ]; then
      echo "Usage: $0 <listen address> <port> <data directory>";
      exit 1;
    fi

    SERVE_DIR=$(dirname "$0")/../php/
    IFM_ROOT_DIR="$3" ${lib.getExe php83} -S "$1:$2" -t "$SERVE_DIR"
  '';
in
stdenv.mkDerivation {
  pname = "ifm";
  inherit version src;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/php
    cp $src $out/php/index.php
    cp ${serve_script} $out/bin/ifm
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) ifm;
  };

  meta = {
    description = "Improved File Manager, a single-file web-based filemanager";
    longDescription = ''
      The IFM is a web-based filemanager, which comes as a single file solution using HTML5, CSS3, JavaScript and PHP.
    '';
    homepage = "https://github.com/misterunknown/ifm";
    changelog = "https://github.com/misterunknown/ifm/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ litchipi ];
    mainProgram = "ifm";
  };
}
