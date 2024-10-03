{
  lib,
  nixosTests,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
}:
let
  name = "broadcast-box";
  version = "0-unstable-2024-09-13";

  src = fetchFromGitHub {
    repo = "broadcast-box";
    owner = "Glimesh";
    rev = "c033d6e29d3ab2c38d98d4aee6df6d59eca8d20c";
    hash = "sha256-rTFE/rCFgc6+N/Y8FG8UpJn3gqKKLjn0fCkmKTBhLzc=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${name}-web";
    src = "${src}/web";
    npmDepsHash = "sha256-+BBUmj6K4d4knon3r4OwGRlSeBvjGKwFEbTWmgvA6jY=";
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
  vendorHash = "sha256-vF0xrMBgBRZOcptItdXQpjKMpntTq34nFAClp/3VgNw=";
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
