{
  lib,
  nixosTests,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
}:
let
  name = "broadcast-box";
  version = "2.0.2-unstable-2026-06-25";

  src = fetchFromGitHub {
    repo = "broadcast-box";
    owner = "Glimesh";
    rev = "97db1f64d247478571d6500aaab72a7a997b4c75";
    hash = "sha256-QFGInrjPWsIXaFJjQkHZcERAPA8VsKZV4wsLl0scDbc=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${name}-web";
    src = "${src}/web";
    npmDepsHash = "sha256-lvW8iyfGprhaegWEXqfwYzPKeieVJ/6O/ka9H5R5a0Y=";
    preBuild = ''
      # The VITE_API_PATH environment variable is needed
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
  vendorHash = "sha256-NQoDxuuYsIvUGf2W+bShEhgCrWrliz45c8+v48tHKp0=";
  proxyVendor = true; # fixes darwin/linux hash mismatch

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
    maintainers = with lib.maintainers; [ JManch ];
    platforms = lib.platforms.unix;
    mainProgram = "broadcast-box";
  };
}
