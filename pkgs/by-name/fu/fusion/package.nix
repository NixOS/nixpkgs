{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  buildGoModule,
  mockgen,
  nixosTests,
  nix-update-script,
}:
buildGoModule rec {
  pname = "fusion";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "0x2E";
    repo = "fusion";
    rev = "v${version}";
    hash = "sha256-nI587lshHlwZMnGGtzkLSaWc8OvY8QfPsdmAR2j+slI=";
  };

  frontend = buildNpmPackage {
    pname = "fusion-frontend";
    inherit version;
    src = "${src}/frontend";

    patches = [ ./frontend-pin-version.patch ];

    npmDepsHash = "sha256-sOdviGGVB41IjO2tpw655dSxuqxufQGo2CqmsjNCDn0=";

    installPhase = ''
      runHook preInstall

      cp -r build $out

      runHook postInstall
    '';
  };

  vendorHash = "sha256-isSoDDJLWIxmihu9txcPMDBJ+l323yrfXqyhqtEAoUI=";

  subPackages = [ "cmd/server" ];

  overrideModAttrs = prev: {
    nativeBuildInputs = prev.nativeBuildInputs ++ [ mockgen ];

    preBuild = ''
      go generate ./...
    '';
  };

  preBuild = ''
    cp -r ${frontend} frontend/build
  '';

  postInstall = ''
    mv $out/bin/server $out/bin/fusion
  '';

  passthru = {
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) fusion;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lightweight, self-hosted friendly RSS aggregator and reader";
    homepage = "https://github.com/0x2E/fusion";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "fusion";
  };
}
