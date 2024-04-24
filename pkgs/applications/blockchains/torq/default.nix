{ lib
, buildGoModule
, buildNpmPackage
, fetchFromGitHub
}:

let
  pname = "torq";
  version = "0.18.19";

  src = fetchFromGitHub {
    owner = "lncapital";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qJIAH8SrB5a7j6ptorEm6fryZj63vDQIUQIgRsVn1us=";
  };

  web = buildNpmPackage {
    pname = "${pname}-frontend";
    inherit version;
    src = "${src}/web";
    npmDepsHash = "sha256-WulYJE2pdVa5hquV/7UjR1z9PkglJXOq5fv8nLa4wos=";

    # copied from upstream Dockerfile
    npmInstallFlags = [ "--legacy-peer-deps" ];
    TSX_COMPILE_ON_ERROR="true";
    ESLINT_NO_DEV_ERRORS="true";

    # override npmInstallHook, we only care about the build/ directory
    installPhase = ''
      mkdir $out
      cp -r build/* $out/
    '';
  };
in
buildGoModule rec {
  inherit pname version src;

  vendorHash = "sha256-bvisI589Gq9IdyJEqI+uzs3iDPOTUkq95P3n/KoFhF0=";

  subPackages = [ "cmd/torq" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/lncapital/torq/build.version=v${version}"
  ];

  postInstall = ''
    mkdir -p $out/web/build
    cp -r ${web}/* $out/web/build/
  '';

  meta = with lib; {
    description = "Capital management tool for lightning network nodes";
    license = licenses.mit;
    homepage = "https://github.com/lncapital/torq";
    maintainers = with maintainers; [ mmilata prusnak ];
    mainProgram = "torq";
  };
}
