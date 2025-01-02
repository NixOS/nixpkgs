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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "daeuniverse";
    repo = "dae";
    rev = "v${version}";
    hash = "sha256-yW3GDflTd9I4RreWtLQE92aP7BnswJHx44jmTZ81kP8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-nThkNyH6TUcFej9IGJ/jME0dGK517d5vJueNU7x86o8=";

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
