{
  stdenv,
  fetchFromGitHub,
  lib,
  pkgs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "arftracksat";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "arf20";
    repo = "arftracksat";
    rev = "69d3c3b21c5000aa308663bc51eae2dc81b6b885";
    sha256 = "sha256-RKIT3WOqCHgeeW6gNZxe/JDTVMf5NZnl4QoQqLJUKUs=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    mesa
    tree
  ];

  buildInputs = with pkgs; [
    curl
    curlpp
    nlohmann_json
    freeglut
    libGL
    mesa_glu
    glm
  ];

  # Patch share location
  patchPhase = ''
    runHook prePatch

    path=${placeholder "out"}
    sed -i "s,/usr/local,$path," src/main.cpp
    sed -i "s,/usr/local,$path," config.json

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 0555 arftracksat $out/bin/arftracksat
    install -D ../config.json $out/etc/arftracksat/config.json
    install -d $out/share/arftracksat/
    install -D ../assets/* $out/share/arftracksat/

    runHook postInstall
  '';

  meta = {
    description = "Graphical satellite tracking software for Linux";
    platforms = lib.platforms.linux;
    homepage = "https://github.com/arf20/arftracksat";
    license = lib.licenses.free; # See https://github.com/arf20/arftracksat/issues/40
    maintainers = with lib.maintainers; [ mabster314 ];
    mainProgram = "arftracksat";
  };
})
