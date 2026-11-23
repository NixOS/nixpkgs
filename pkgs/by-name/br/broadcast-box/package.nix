{
  lib,
  nixosTests,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
}:
let
  pname = "broadcast-box";
  version = "2.1.1";

  src = fetchFromGitHub {
    repo = "broadcast-box";
    owner = "Glimesh";
    tag = "v${version}";
    hash = "sha256-7SseHl5ii1kE5PYYal8ZIbP6tJeZjMwP063Ia/++u1E=";
  };

  mkFrontend =
    finalAttrs:
    buildNpmPackage {
      inherit (finalAttrs) version;
      pname = "${finalAttrs.pname}-web";
      src = "${finalAttrs.src}/web";
      npmDepsHash = "sha256-eDbq/jhbPq98TmfYuh6rBid+HG7NxkPVufWC7YFtcKo=";

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r build $out

        runHook postInstall
      '';
    };
in
buildGoModule (finalAttrs: {
  inherit pname version src;
  vendorHash = "sha256-0LyylgNtAD/HT/ojhyI2eo5e8G4+4BU1jO4zXkohAIs=";
  proxyVendor = true; # fixes darwin/linux hash mismatch

  frontend = mkFrontend finalAttrs;

  postPatch = ''
    substituteInPlace internal/environment/environment.go \
      --replace-fail './web/build' '${placeholder "out"}/share'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    ln -s $frontend/build/* $out/share

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
    maintainers = with lib.maintainers; [
      JManch
      joturk
    ];
    platforms = lib.platforms.unix;
    mainProgram = "broadcast-box";
  };
})
