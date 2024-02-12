{ lib
, nixosTests
, fetchFromGitHub
, buildNpmPackage
, buildGoModule
}:
let
  name = "broadcast-box";
  version = "2024-03-20";

  src = fetchFromGitHub {
    repo = "broadcast-box";
    owner = "Glimesh";
    rev = "b37dd4ce79741849e1601812ac7f70fa6a2e0f02";
    sha256 = "sha256-kDpDELp7yjDtCwZYd1rg/JsemE9zTxQh1Bucz9pgl3o=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${name}-web";
    src = "${src}/web";
    npmDepsHash = "sha256-/rlyfQMolsfgtk9wxfi5DUy/ZxCny5ahKGu9aoJEzWw=";
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
  vendorHash = "sha256-in31kbbZAexbHuqeZ8BpPw3jCTeJsEHM2IGajXlyIDg=";
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

    cp -r "$GOPATH/bin" $out

    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) broadcast-box; };

  meta = with lib; {
    description = "WebRTC broadcast server";
    homepage = "https://github.com/Glimesh/broadcast-box";
    license = licenses.mit;
    maintainers = with maintainers; [ JManch ];
    platforms = platforms.unix;
    mainProgram = "broadcast-box";
  };
}
