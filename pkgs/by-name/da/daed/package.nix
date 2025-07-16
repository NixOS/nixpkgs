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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "daed";
    tag = "v${version}";
    hash = "sha256-WaybToEcFrKOcJ+vfCTc9uyHkTPOrcAEw9lZFEIBPgY=";
    fetchSubmodules = true;
  };

  web = stdenv.mkDerivation {
    inherit pname version src;

    pnpmDeps = pnpm_9.fetchDeps {
      inherit pname version src;
      fetcherVersion = 1;
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

  vendorHash = "sha256-+uf8PJQvsJMUyQ6W+nDfdwrxBO2YRUL328ajTJpVDZk=";

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

  postInstall = ''
    install -Dm444 $src/install/daed.service -t $out/lib/systemd/system
    substituteInPlace $out/lib/systemd/system/daed.service \
      --replace-fail /usr/bin $out/bin
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
