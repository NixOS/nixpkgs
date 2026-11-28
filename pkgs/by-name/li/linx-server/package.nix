{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenv,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs_24,
  pnpm_11,
}:
let
  pname = "linx-server-gabe565";
  version = "2026-08-15";

  src = fetchFromGitHub {
    owner = "gabe565";
    repo = "linx-server";
    rev = "34fb43876850cfae410f965901cefc6d992a7ac3";
    hash = "sha256-I76yAhwaBY8w3aWpeW8HRcLz8zUNX0j7lt3cqG7Wkak=";
  };
  frontend-assets = stdenv.mkDerivation {
    pname = "${pname}-frontend";
    inherit version src;

    nativeBuildInputs = [
      pnpmConfigHook
      nodejs_24
      pnpm_11
    ];

    sourceRoot = "${src.name}/assets/static";

    pnpmDeps = fetchPnpmDeps {
      pname = "${pname}-pnpm-deps";
      inherit version;
      src = "${src}/assets/static";
      hash = "sha256-ulBRt0BUKjy5uDtblUDDiyz705N94Vw19dOgWw7dROc=";
      fetcherVersion = 4;
    };

    buildPhase = ''
      runHook preBuild
      pnpm build
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out
      cp -r dist/. $out/
    '';
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-DHVB2MO2oOgO3lhz+fbw/ksmq9ruhc6o8dboYxeGuIc=";

  preBuild = ''
    rm -rf assets/static/dist
    mkdir -p assets/static/dist
    cp -r ${frontend-assets}/. assets/static/dist/
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Self-hosted file/code/media sharing website (gabe565 fork)";
    homepage = "https://github.com/gabe565/linx-server";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ petingoso ];
  };
}
