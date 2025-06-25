{
  lib,
  clang,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
  nix-update-script,
}:
buildGoModule rec {
  pname = "dae";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "dae";
    rev = "v${version}";
    hash = "sha256-RpbWZEoGrCq3Py0hu6YDie6ErDTLS3oabqScPzhCtm0=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-u2DCHmX7vRNWIQ2Ir3UrxPGduggEqoUr1rnkDfwsT0I=";

  proxyVendor = true;

  nativeBuildInputs = [ clang ];

  hardeningDisable = [
    "zerocallusedregs"
  ];

  buildPhase = ''
    runHook preBuild

    make CFLAGS="-D__REMOVE_BPF_PRINTK -fno-stack-protector -Wno-unused-command-line-argument" \
    NOSTRIP=y \
    VERSION=${version} \
    OUTPUT=$out/bin/dae

    runHook postBuild
  '';

  # network required
  doCheck = false;

  postInstall = ''
    install -Dm444 install/dae.service $out/lib/systemd/system/dae.service
    substituteInPlace $out/lib/systemd/system/dae.service \
      --replace /usr/bin/dae $out/bin/dae
  '';

  passthru.tests = {
    inherit (nixosTests) dae;
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Linux high-performance transparent proxy solution based on eBPF";
    homepage = "https://github.com/daeuniverse/dae";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      oluceps
      pokon548
      luochen1990
    ];
    platforms = platforms.linux;
    mainProgram = "dae";
  };
}
