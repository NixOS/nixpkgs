{
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  stdenvNoCC,
  clang,
  buildGoModule,
  fetchFromGitHub,
  lib,
  _experimental-update-script-combinators,
  nixosTests,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
buildGoModule (finalAttrs: {
  pname = "daed";
  version = "1.27.0";
  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "daed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CvxCDdOLsdSlFfmoR+C1IUt9HvkAV5JsWGI94DLXB+U=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/wing";

  web = stdenvNoCC.mkDerivation {
    inherit (finalAttrs) pname version src;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        ;
      inherit pnpm;
      fetcherVersion = 3;
      hash = "sha256-2g/M+4XI1EM+c7W82qyfH8C7sX+Y0QACiSpn65Vei4g=";
    };

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpm
    ];

    strictDeps = true;
    __structuredAttrs = true;

    buildPhase = ''
      runHook preBuild

      pnpm build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R apps/web/dist/* $out

      runHook postInstall
    '';
  };

  vendorHash = "sha256-l7jgMvrbpOY2+cvnc0e5cvSgKVm4GcWC+bPbff+PE80=";
  proxyVendor = true;

  nativeBuildInputs = [ clang ];

  hardeningDisable = [ "zerocallusedregs" ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace-fail /bin/bash /bin/sh

    # ${finalAttrs.web} does not have write permission
    mkdir dist
    cp -r ${finalAttrs.web}/* dist
    chmod -R 755 dist
  '';

  buildPhase = ''
    runHook preBuild

    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector -Wno-unused-command-line-argument" \
      NOSTRIP=y \
      WEB_DIST=dist \
      AppName=${finalAttrs.pname} \
      VERSION=${finalAttrs.version} \
      OUTPUT=$out/bin/daed \
      bundle

    runHook postBuild
  '';

  postInstall = ''
    install -Dm444 $src/install/daed.service -t $out/lib/systemd/system
    substituteInPlace $out/lib/systemd/system/daed.service \
      --replace-fail /usr/bin $out/bin
  '';

  passthru = {
    inherit (finalAttrs) web;
    tests = { inherit (nixosTests) daed; };
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        attrPath = "daed.web";
        extraArgs = [ "--use-github-releases" ];
      })
      (nix-update-script {
        extraArgs = [ "--version=skip" ];
      })
    ];
  };

  meta = {
    description = "Modern dashboard with dae";
    homepage = "https://github.com/daeuniverse/daed";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      oluceps
      ccicnce113424
    ];
    platforms = lib.platforms.linux;
    mainProgram = "daed";
  };
})
