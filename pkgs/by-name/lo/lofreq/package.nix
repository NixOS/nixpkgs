{
  lib,
  stdenv,
  fetchFromGitHub,

  autoreconfHook,
  htslib,
  python3,
  zlib,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lofreq";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "CSB5";
    repo = "lofreq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dA2B3dCD6LbJ1hS87XVR442GJc2B4WhcO1PJV4fNWmM=";

    postFetch = ''
      # just .tar.gz'd tag archives -- too large for no use with keeping
      rm -rf dist
    '';
  };

  nativeBuildInputs = [
    autoreconfHook
  ];
  buildInputs = [
    htslib
    python3
    zlib
  ];

  configureFlags = [
    # entirely optional -- extremely useful but:
    # would depend on PyVCF which was removed in #232816 due to using 2to3
    "--disable-tools"
  ];

  # does have tests, but those rely on some `data` directory i can't seem to find

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "lofreq";
    description = "Sensitive variant calling from sequencing data";
    homepage = "https://csb5.github.io/lofreq/";
    license = lib.licenses.mit;

    maintainers = with lib.maintainers; [
      multisn8
    ];
  };
})
