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
      npmDepsHash = "sha256-oiOv4d+Gxk43gUAZXrTpcsfuEEpGyJMYS19ZRHf9oF8=";

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
    version = "2.13.0";

    src = fetchFromGitHub {
      owner = "binwiederhier";
      repo = "ntfy";
      tag = "v${finalAttrs.version}";
      hash = "sha256-D4wLIGVItH5lZlfmgd2+QsqB4PHlyX4ORpwT1NGdV60=";
    };

    vendorHash = "sha256-7+nvkyLcdQZ/B4Lly4ygcOGxSLkXXqCqu7xvCB4+8Wo=";

    doCheck = false;

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${finalAttrs.version}"
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
