{
  stdenv,
  lib,
  python3,
  fetchzip,
  testers,
  valgrind,
  valgrindSupport ?
    lib.meta.availableOn stdenv.hostPlatform valgrind && !(valgrind.meta.broken or false),
  librandombytes,
  libcpucycles,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lib25519";
  version = "20260614";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://lib25519.cr.yp.to/lib25519-${finalAttrs.version}.tar.gz";
    hash = "sha256-k6hVfUckgrRGVmvbt5SW3Vg1woscGzPBpOYnfYx5t44=";
  };

  patches = [ ./environment-variable-tools.patch ];

  postPatch = ''
    patchShebangs configure
    patchShebangs scripts-build
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    find . -name '*.S' -type f -exec \
      sed -i '/^\.section\t\.note\.GNU-stack,"",@progbits/d' {} +
  '';

  # NOTE: lib25519 uses a custom Python `./configure`: it does not expect standard
  # autoconfig --build --host etc. arguments: disable
  # Pass the hostPlatform string
  configurePhase = ''
    runHook preConfigure
    ./configure --host=${stdenv.buildPlatform.system} --prefix=$out ${
      lib.optionalString (!valgrindSupport) "--no-valgrind"
    }
    runHook postConfigure
  '';

  nativeBuildInputs = [
    (python3.withPackages (ps: [ ps.capstone ]))
  ]
  ++ lib.optionals valgrindSupport [
    valgrind
  ];
  buildInputs = [
    librandombytes
    libcpucycles
  ]
  ++ lib.optionals valgrindSupport [
    valgrind
  ];

  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id "$out/lib/lib25519.1.dylib" "$out/lib/lib25519.1.dylib"
    for f in $out/bin/*; do
      # Skip python script, fails on aarch64-darwin otherwise
      if [[ "$f" != "$out/bin/lib25519-fulltest" ]]; then
        install_name_tool -change "lib25519.1.dylib" "$out/lib/lib25519.1.dylib" "$f"
      fi
    done
  '';

  # failure: crypto_pow does not handle p=q overlap
  doInstallCheck = !stdenv.hostPlatform.isDarwin;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/lib25519-test
    runHook postInstallCheck
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "lib25519-test | head -n 2 | grep version";
      version = "lib25519 version ${finalAttrs.version}";
    };
  };

  meta = {
    homepage = "https://lib25519.cr.yp.to";
    description = "Microlibrary for X25519/Ed25519 cryptography";
    changelog = "https://lib25519.cr.yp.to/download.html";
    license =
      # Upstream specifies the public domain licenses with the terms here https://lib25519.cr.yp.to/license.html
      lib.licenses.OR [
        lib.licenses.publicDomain
        lib.licenses.cc0
        lib.licenses.bsd0
        lib.licenses.mit
        lib.licenses.mit0
      ];
    maintainers = with lib.maintainers; [
      kiike
      imadnyc
      jleightcap
    ];
    teams = with lib.teams; [ ngi ];
    # This supports whatever platforms libcpucycles supports
    inherit (libcpucycles.meta) platforms;
  };
})
