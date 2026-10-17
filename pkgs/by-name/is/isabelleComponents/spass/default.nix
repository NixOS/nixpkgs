{
  stdenv,
  fetchzip,
  bison,
  flex,
  writeTextFile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spass";
  version = "3.8ds";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://www.cs.vu.nl/~jbe248/spass-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-DqDNNyMwDXznrUpgP6iZ6qwcHXiP1wHsmp+zken7EmU=";
  };

  patches = [ ./fix-gcc15-compile.patch ];

  nativeBuildInputs = [
    bison
    flex
  ];

  buildFlags = [
    "RM=\"rm -f\""
    "SPASS"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 SPASS $out/bin/SPASS

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "spass-settings";
    text = ''
      SPASS_HOME="${finalAttrs.finalPackage}/bin"
      SPASS_VERSION="${finalAttrs.version}"
    '';
    destination = "/etc/settings";
  };
})
