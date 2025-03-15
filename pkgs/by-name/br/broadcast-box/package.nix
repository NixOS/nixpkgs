{
  lib,
  nixosTests,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
}:
let
  name = "broadcast-box";
  version = "0-unstable-2024-12-18";

  src = fetchFromGitHub {
    repo = "broadcast-box";
    owner = "Glimesh";
    rev = "9eba6d6e18f34b881e16b225ffe2ac90e18d4f2d";
    hash = "sha256-bbz/75yepZMeEtqFveLXOxCw7vA9aVtRGGhX4jvzGyE=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${name}-web";
    src = "${src}/web";
    npmDepsHash = "sha256-jCeBqreHU1yak2QDFceCMJ7gr/TBDRPmVCB/ZykCm3k=";
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
  vendorHash = "sha256-upaR4esNZ3QB39brvysCT0xKgfh4ErXzgE3d9izE2C8=";
  proxyVendor = true; # fixes darwin/linux hash mismatch

  patches = [ ./allow-no-env.patch ];
  postPatch = ''
    substituteInPlace main.go \
      --replace-fail './web/build' '${placeholder "out"}/share'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r $frontend/build/* $out/share

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
