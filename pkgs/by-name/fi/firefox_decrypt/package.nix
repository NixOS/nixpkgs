{
  lib,
  fetchFromGitHub,
  nss,
  nixosTests,
  nix-update-script,
  stdenv,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "firefox_decrypt";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unode";
    repo = "firefox_decrypt";
    tag = finalAttrs.version;
    hash = "sha256-Y958qXGpkNgMBYiM80OKQYkO7EdqH7T5FfINELAB9CY=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
    wheel
  ];

  makeWrapperArgs = [
    "--prefix"
    (if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH")
    ":"
    (lib.makeLibraryPath [ nss ])
  ];

  checkPhase = ''
    runHook preCheck

    patchShebangs tests
    (cd tests && ${
      if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"
    }=${lib.makeLibraryPath [ nss ]} ./run_all)

    runHook postCheck
  '';

  passthru = {
    tests = {
      inherit (nixosTests) firefox_decrypt;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/unode/firefox_decrypt";
    description = "Tool to extract passwords from profiles of Mozilla Firefox and derivates";
    mainProgram = "firefox-decrypt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      schnusch
      unode
    ];
  };
})
