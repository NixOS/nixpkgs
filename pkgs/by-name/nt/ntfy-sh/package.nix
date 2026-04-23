{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
  nixosTests,
  debianutils,
  mkdocs,
  python3,
  python3Packages,
}:

buildGoModule (
  finalAttrs:

  let
    ui = buildNpmPackage {
      inherit (finalAttrs) src version;
      pname = "ntfy-sh-ui";
      npmDepsHash = "sha256-PmhWzktybM6Cg7yYRfbxWE83C+XkmHh4garHhsydwwE=";

      prePatch = ''
        cd web/
      '';

      installPhase = ''
        runHook preInstall

        mv build/index.html build/app.html
        rm build/config.js
        mkdir -p $out
        mv build/ $out/site

        runHook postInstall
      '';
    };
  in
  {
    pname = "ntfy-sh";
    version = "2.19.2";

    src = fetchFromGitHub {
      owner = "binwiederhier";
      repo = "ntfy";
      tag = "v${finalAttrs.version}";
      hash = "sha256-HISQnb6LkKGujZsWCzVD3dTuobhUXqrmTFuov7dU+lY=";
    };

    vendorHash = "sha256-mr2PbxT5QWf4HZGgUg+oUjauqmZ6bh6N3f0ytwPDppU=";

    doCheck = false;

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${finalAttrs.version}"
    ];

    excludedPackages = [
      # main module (heckel.io/ntfy/v2) does not contain package heckel.io/ntfy/v2/tools/loadtest
      "tools/loadtest"
    ];

    nativeBuildInputs = [
      debianutils
      mkdocs
      python3
      python3Packages.mkdocs-material
      python3Packages.mkdocs-minify-plugin
    ];

    postPatch = ''
      sed -i 's# /bin/echo# echo#' Makefile
    '';

    preBuild = ''
      cp -r ${ui}/site/ server/
      make docs-build
    '';

    passthru = {
      updateScript = ./update.sh;
      tests.ntfy-sh = nixosTests.ntfy-sh;
    };

    meta = {
      description = "Send push notifications to your phone or desktop via PUT/POST";
      homepage = "https://ntfy.sh";
      changelog = "https://github.com/binwiederhier/ntfy/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        arjan-s
        fpletz
        matthiasbeyer
      ];
      mainProgram = "ntfy";
    };
  }
)
