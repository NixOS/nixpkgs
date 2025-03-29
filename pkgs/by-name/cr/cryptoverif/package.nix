{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cryptoverif";
  version = "2.11";

  src = fetchurl {
    url = "http://prosecco.gforge.inria.fr/personal/bblanche/cryptoverif/cryptoverif${finalAttrs.version}.tar.gz";
    hash = "sha256-duc7t0Qpr1Z2FZEoufdQ7kcBlLbXHO+r9ivEgUxqK9s=";
  };

  /*
    Fix up the frontend to load the 'default' cryptoverif library
    ** from under $out/libexec. By default, it expects to find the files
    ** in $CWD which doesn't work.
  */
  postPatch = ''
    substituteInPlace ./src/syntax.ml \
      --replace \"default\" \"$out/libexec/default\"
  '';

  strictDeps = true;

  nativeBuildInputs = [ ocaml ];

  buildPhase = ''
    runHook preBuild

    ./build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec
    cp ./cryptoverif   $out/bin
    cp ./default.cvl   $out/libexec
    cp ./default.ocvl  $out/libexec

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-cryptoverif" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl pcre2

    set -eu -o pipefail

    version="$(curl -s https://bblanche.gitlabpages.inria.fr/CryptoVerif/ |
      pcre2grep -o1 '\bCryptoVerif version ([.[:alnum:]]+),')"

    update-source-version "$UPDATE_NIX_ATTR_PATH" "$version"
  '';

  meta = {
    description = "Cryptographic protocol verifier in the computational model";
    mainProgram = "cryptoverif";
    homepage = "https://bblanche.gitlabpages.inria.fr/CryptoVerif/";
    license = lib.licenses.cecill-b;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
})
