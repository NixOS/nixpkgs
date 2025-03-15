{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  alsa-lib,
  libpulseaudio,
  nix-update-script,
  testers,
  audioBackend ? "pulseaudio",
}:
assert lib.assertOneOf "audioBackend" audioBackend [
  "alsa"
  "pulseaudio"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "flite";
  version = "2.2";

  outputs = [
    "bin"
    "dev"
    "lib"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "festvox";
    repo = "flite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tq5pyg3TiQt8CPqGXTyLOaGgaeLTmPp+Duw3+2VAF9g=";
  };

  patches =
    [
      # https://github.com/festvox/flite/pull/60.
      # Replaces `ar` with `$(AR)` in config/common_make_rules.
      # Improves cross-compilation compatibility.
      (fetchpatch {
        url = "https://github.com/festvox/flite/commit/54c65164840777326bbb83517568e38a128122ef.patch";
        hash = "sha256-hvKzdX7adiqd9D+9DbnfNdqEULg1Hhqe1xElYxNM1B8=";
      })
    ]
    # Fixes (fortified) builds with clang against glibc >= 2.40
    # https://lists.openembedded.org/g/openembedded-devel/message/111217
    # https://github.com/NixOS/nixpkgs/issues/384409
    ++ lib.optional (
      stdenv.cc.isClang && stdenv.hostPlatform.libc == "glibc"
    ) ./0001-Remove-defining-const-as-nothing.patch;

  buildInputs = lib.optional stdenv.hostPlatform.isLinux (
    {
      alsa = alsa-lib;
      pulseaudio = libpulseaudio;
    }
    .${audioBackend} or (throw "${audioBackend} is not a supported backend!")
  );

  configureFlags = [
    "--enable-shared"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "--with-audio=${audioBackend}" ];

  # main/Makefile creates and removes 'flite_voice_list.c' from multiple targets:
  # make[1]: *** No rule to make target 'flite_voice_list.c', needed by 'all'.  Stop
  enableParallelBuilding = false;

  passthru = {
    tests.version = testers.testVersion {
      # `flite` does have a `--version` command, but it returns 1
      command = "flite --help";
      package = finalAttrs.finalPackage;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Small, fast run-time speech synthesis engine";
    homepage = "http://www.festvox.org/flite/";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "flite";
  };
})
