{
  lib,
  stdenv,
  fetchFromGitHub,
  pciutils,
  cmake,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ryzenadj";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "FlyGoat";
    repo = "RyzenAdj";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-SNtCKZ3bugawzD8R3DjwPs/ls3kyTw1LdIcXuR6fumc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pciutils
  ];

  strictDeps = true;

  installPhase = ''
    install -D libryzenadj.so $out/lib/libryzenadj.so
    install -D ryzenadj $out/bin/ryzenadj
  '';

  meta = {
    description = "Adjust power management settings for Ryzen Mobile Processors";
    mainProgram = "ryzenadj";
    homepage = "https://github.com/FlyGoat/RyzenAdj";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ rhendric ];
    platforms = [ "x86_64-linux" ];
  };
})
