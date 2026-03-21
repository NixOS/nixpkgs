{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  openssl,
}:

stdenv.mkDerivation {
  pname = "hash_extender";
  version = "unstable-2020-03-24";

  src = fetchFromGitHub {
    owner = "iagox86";
    repo = "hash_extender";
    rev = "cb8aaee49f93e9c0d2f03eb3cafb429c9eed723d";
    sha256 = "1fj118566hr1wv03az2w0iqknazsqqkak0mvlcvwpgr6midjqi9b";
  };

  patches = [
    # gcc-15 build fix:
    #   https://github.com/iagox86/hash_extender/pull/15
    (fetchpatch {
      name = "gcc-15.patch";
      url = "https://github.com/iagox86/hash_extender/commit/84d8d70eb10bcbe4dea2cf5a41d246d59a389e61.patch";
      hash = "sha256-LCzv4FK+4WoJBYYUYB+zsC6358ZpTOxbE91W/1pFe6U=";
    })
  ];

  buildInputs = [ openssl ];

  enableParallelBuilding = true;
  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ./hash_extender --test

    runHook postCheck
  '';

  # https://github.com/iagox86/hash_extender/issues/26
  hardeningDisable = [ "fortify3" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp hash_extender $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Tool to automate hash length extension attacks";
    mainProgram = "hash_extender";
    homepage = "https://github.com/iagox86/hash_extender";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
