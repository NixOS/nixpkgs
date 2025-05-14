{
  pnpm_9,
  nodejs,
  stdenv,
  clang,
  buildGoModule,
  fetchFromGitHub,
  lib,
  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  pname = "daed";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "daed";
    tag = "v${version}";
    hash = "sha256-5olEPaS/6ag69KUwBG8qXpyr1B2qrLK+vf13ZljHH+c=";
    fetchSubmodules = true;
  };

  web = stdenv.mkDerivation {
    inherit pname version src;

    pnpmDeps = pnpm_9.fetchDeps {
      inherit pname version src;
      hash = "sha256-+yLpSbDzr1OV/bmUUg6drOvK1ok3cBd+RRV7Qrrlp+Q=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm_9.configHook
    ];

    buildPhase = ''
      runHook preBuild

      pnpm build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -R dist $out

      runHook postInstall
    '';
  };
in

buildGoModule rec {
  inherit
    pname
    version
    src
    web
    ;

  sourceRoot = "${src.name}/wing";

  vendorHash = "sha256-qB2qcJ82mFcVvjlYp/N9sqzwPotTROgymSX5NfEQMuY=";

  proxyVendor = true;

  nativeBuildInputs = [ clang ];

  hardeningDisable = [ "zerocallusedregs" ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace-fail /bin/bash /bin/sh

    # ${web} does not have write permission
    mkdir dist
    cp -r ${web}/* dist
    chmod -R 755 dist
  '';

  buildPhase = ''
    runHook preBuild

    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector -Wno-unused-command-line-argument" \
      NOSTRIP=y \
      WEB_DIST=dist \
      AppName=${pname} \
      VERSION=${version} \
      OUTPUT=$out/bin/daed \
      bundle

    runHook postBuild
  '';

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script {
      attrPath = "daed.web";
    })
    (nix-update-script {
      extraArgs = [ "--version=skip" ];
    })
  ];

  meta = {
    description = "Modern dashboard with dae";
    homepage = "https://github.com/daeuniverse/daed";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oluceps ];
    platforms = lib.platforms.linux;
    mainProgram = "daed";
  };
}
