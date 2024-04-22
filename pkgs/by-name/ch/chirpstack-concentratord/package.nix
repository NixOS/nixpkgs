{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  protobuf,
}:
let
  libloragw-sx1301 = stdenv.mkDerivation rec {
    pname = "libloragw-sx1301";
    version = "5.0.1r2";

    src = fetchFromGitHub {
      owner = "brocaar";
      repo = "lora_gateway";
      rev = "59381129a07858a2a91aeffe21cd6a728219cf23";
      hash = "sha256-K+GCE3eJq/9CgjIPTCBx3dSbDP0QbTiv0QMAbbLZM7s=";
    };

    makeFlags = [
      "-e"
      "-C"
      "libloragw"
    ];

    installPhase = ''
      mkdir -p $out/{lib,include/libloragw-sx1301}
      cp libloragw/libloragw.a $out/lib/libloragw-sx1301.a
      cp libloragw/inc/* $out/include/libloragw-sx1301
    '';
  };

  libloragw-sx1302 = stdenv.mkDerivation rec {
    pname = "libloragw-sx1302";
    version = "2.1.0r7";

    src = fetchFromGitHub {
      owner = "brocaar";
      repo = "sx1302_hal";
      rev = "c3d99009556fdfe273c3a53306082ef181333c7a";
      hash = "sha256-Ue3C7XbaCv/d0NIMclPSE+qcQpxw70DVhXlnpFACzhY=";
    };

    makeFlags = [
      "-e"
      "-C"
      "libloragw"
    ];

    preBuild = ''
      make -C libtools
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{lib,include/libloragw-sx1302}
      cp libloragw/libloragw.a $out/lib/libloragw-sx1302.a
      cp libloragw/inc/* $out/include/libloragw-sx1302
      cp libtools/*.a $out/lib/
      cp libtools/inc/* $out/include/

      runHook postInstall
    '';
  };

  libloragw-2g4 = stdenv.mkDerivation rec {
    pname = "libloragw-2g4";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "Lora-net";
      repo = "gateway_2g4_hal";
      rev = "f14f5cf2e4caf3789bc32159fba5c10363166591";
      hash = "sha256-EvsYCkZ55nEdZXhxp7AjCw954+uUIoi2Fc3xhaIjZys=";
    };

    makeFlags = [
      "-e"
      "-C"
      "libloragw"
    ];

    preBuild = ''
      make -C libtools
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{lib,include/libloragw-2g4}
      cp libloragw/libloragw.a $out/lib/libloragw-2g4.a
      cp libloragw/inc/* $out/include/libloragw-2g4

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage rec {
  pname = "chirpstack-concentratord";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-concentratord";
    rev = "v${version}";
    hash = "sha256-Uppqyq0Dz6q5//HCvnO0lg60ltvPGbFn2/pByEecZyQ=";
  };

  cargoHash = "sha256-9bR62KnZ7+f6ioQdNv4GJ1I3/LX2WF+7rrD4y8CNi+E=";

  buildInputs = [
    libloragw-2g4
    libloragw-sx1301
    libloragw-sx1302
  ];

  nativeBuildInputs = [
    protobuf
    rustPlatform.bindgenHook
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Concentrator HAL daemon for LoRa gateways";
    homepage = "https://www.chirpstack.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ stv0g ];
    platforms = [ "aarch64-linux" ];
    mainProgram = "chirpstack-concentratord";
  };
}
