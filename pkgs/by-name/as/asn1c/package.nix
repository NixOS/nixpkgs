{
  lib,
  stdenv,
  autoreconfHook,
  versionCheckHook,
  fetchFromGitHub,
  perl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asn1c";
  version = "0.9.29";

  src = fetchFromGitHub {
    owner = "vlm";
    repo = "asn1c";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ms4+tzlVdV0pVGhdBod8sepjHGS4OVxJb3HdrFKv9Cc=";
  };

  outputs = [
    "out"
    "doc"
    "man"

    # for the one perl utility
    "crfc2asn1"
  ];

  postPatch = ''
    patchShebangs examples/crfc2asn1.pl
  '';

  nativeBuildInputs = [
    autoreconfHook
    versionCheckHook
  ];

  buildInputs = [ perl ];

  enableParallelBuilding = true;

  postInstall = ''
    cp -r skeletons/standard-modules $out/share/asn1c
  '';

  # Barely anyone uses this, so make it a split-output
  # so we don't carry the dependency on perl into bin.
  postFixup = ''
    mkdir -p $crfc2asn1/bin
    mv $out/bin/crfc2asn1.pl $crfc2asn1/bin/crfc2asn1
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "asn1c";
    homepage = "https://lionet.info/asn1c/compiler.html";
    description = "Open Source ASN.1 Compiler";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ numinit ];
  };
})
