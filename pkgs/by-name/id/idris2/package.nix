{
  lib,
  stdenv,
  fetchFromGitHub,
  chez,
  chez-racket,
  clang,
  gmp,
  installShellFiles,
  gambit,
  nodejs,
  zsh,
  callPackage,
  idris2Packages,
  testers,
}:
let
  inherit (stdenv.hostPlatform) extensions;

  version = "0.7.0";
  src = fetchFromGitHub {
    owner = "idris-lang";
    repo = "Idris2";
    rev = "v${version}";
    hash = "sha256-VwveX3fZfrxEsytpbOc5Tm6rySpLFhTt5132J6rmrmM=";
  };

  # Runtime library
  libidris2_support = callPackage ./libidris2_support.nix { inherit src version; };
  libsupportLib = lib.makeLibraryPath [ libidris2_support ];
  libsupportShare = lib.makeSearchPath "share" [ libidris2_support ];

  platformChez =
    if (stdenv.system == "x86_64-linux") || (lib.versionAtLeast chez.version "10.0.0") then
      chez
    else
      chez-racket;

  unwrapped = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "idris2";

    postPatch = ''
      shopt -s globstar

      # Patch all occurences of the support lib with an absolute path so it
      # works without wrapping.
      substituteInPlace **/*.idr \
        --replace-quiet "libidris2_support" "${libidris2_support}/lib/libidris2_support${extensions.sharedLibrary}"

      substituteInPlace src/Compiler/RefC/CC.idr \
        --replace-fail "libidris2_support${extensions.sharedLibrary}.a" "libidris2_support.a"

      patchShebangs --build tests
    '';

    strictDeps = true;
    nativeBuildInputs = [
      clang
      platformChez
      installShellFiles
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ zsh ];
    buildInputs = [
      platformChez
      gmp
      libidris2_support
    ];

    enableParallelBuilding = true;

    makeFlags = [
      "PREFIX=${placeholder "out"}"
      "IDRIS2_SUPPORT_DIR=${libsupportLib}"
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin "OS=";

    # The name of the main executable of pkgs.chez is `scheme`
    buildFlags = [
      "bootstrap"
      "SCHEME=scheme"
      "IDRIS2_LIBS=${libsupportLib}"
      "IDRIS2_DATA=${libsupportShare}"
    ];

    doCheck = false;
    checkTarget = "test";
    nativeCheckInputs = [
      gambit
      nodejs
    ];
    checkFlags = [
      "INTERACTIVE="
      "IDRIS2_DATA=${libsupportShare}"
      "IDRIS2_LIBS=${libsupportLib}"
      "TEST_IDRIS2_DATA=${libsupportShare}"
      "TEST_IDRIS2_LIBS=${libsupportLib}"
      "TEST_IDRIS2_SUPPORT_DIR=${libsupportLib}"
    ];

    postInstall = ''
      # Remove existing idris2 wrapper that sets incorrect LD_LIBRARY_PATH
      rm $out/bin/idris2

      # The only thing we need from idris2_app is the actual binary, which is
      # a Chez Scheme object.
      # The extensions is .so on Darwin and Linux for some reason
      mv $out/bin/idris2_app/idris2.so $out/bin/idris2

      rm -rf $out/bin/idris2_app
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd idris2 \
        --bash <($out/bin/idris2 --bash-completion-script idris2)
    '';

    # Run package tests
    passthru = {
      inherit libidris2_support;
      tests = {
        wrapped = testers.testVersion {
          package = finalAttrs.finalPackage.withPackages (p: [ p.idris2Api ]);
        };
      }
      // (callPackage ./tests.nix {
        idris2 = finalAttrs.finalPackage;
        idris2Packages = idris2Packages.override { idris2 = finalAttrs.finalPackage; };
      });

      chez = platformChez;

      withPackages =
        f:
        callPackage ./wrapped.nix {
          idris2-unwrapped = finalAttrs.finalPackage;
          extraPackages = f idris2Packages;
        };
    };

    meta = {
      description = "Purely functional programming language with first class types";
      mainProgram = "idris2";
      homepage = "https://github.com/idris-lang/Idris2";
      changelog = "https://github.com/idris-lang/Idris2/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [
        fabianhjr
        wchresta
        mattpolzin
        RossSmyth
      ];
      platforms = lib.platforms.all;
    };
  });
in
unwrapped.withPackages (_: [ ])
