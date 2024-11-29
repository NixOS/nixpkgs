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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "dae";
    rev = "v${version}";
    hash = "sha256-Vdh5acE5i/bJ8VXOm+9OqZQbxvqv4TS/t0DDfBs/K5g=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-0Q+1cXUu4EH4qkGlK6BIpv4dCdtSKjb1RbLi5Xfjcew=";

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
