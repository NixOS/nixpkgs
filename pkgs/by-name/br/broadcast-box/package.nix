{
  lib,
  nixosTests,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
}:
let
  name = "broadcast-box";
  version = "2024-07-15";

  src = fetchFromGitHub {
    repo = "broadcast-box";
    owner = "Glimesh";
    rev = "323a3f87adff0fcecd7292eae960d666b6f52787";
    hash = "sha256-uKmh0JtzIaO/yGicgcoXV2lRDfjHeJ44qnQ5jFUb8UM=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${name}-web";
    src = "${src}/web";
    npmDepsHash = "sha256-tCKpnvrEGT/y/XaWdfNOTPow/DJCmbZKlv1acLwd3Ew=";
    preBuild = ''
      # The REACT_APP_API_PATH environment variable is needed
      cp "${src}/.env.production" ../
    '';
    installPhase = ''
      mkdir -p $out
      cp -r build $out
    '';
  };
in
buildGoModule {
  inherit version src frontend;
  pname = name;
  vendorHash = "sha256-nYsSFo64WG+UyPDVBIgC7Lc0J4wo6334PNAVPvQQSfY=";
  proxyVendor = true; # fixes darwin/linux hash mismatch

  patches = [ ./allow-no-env.patch ];
  postPatch = ''
    substituteInPlace main.go \
      --replace-fail './web/build' '${placeholder "out"}/share'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r ${frontend}/build/* $out/share

    install -Dm755 $GOPATH/bin/broadcast-box -t $out/bin

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) broadcast-box;
  };

  meta = {
    description = "WebRTC broadcast server";
    homepage = "https://github.com/Glimesh/broadcast-box";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ JManch ];
    platforms = lib.platforms.unix;
    mainProgram = "broadcast-box";
  };
}
