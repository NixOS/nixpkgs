{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  fetchNpmDeps,
  npmHooks,
  nodejs,

  python3,
  libtool,
  cctools,

  mailpit,
  nixosTests,
  testers,
}:

let
  source = import ./source.nix;

  inherit (source)
    version
    vendorHash
    ;

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "mailpit";
    rev = "v${version}";
    hash = source.hash;
  };

  libtool' = if stdenv.hostPlatform.isDarwin then cctools else libtool;

  # Separate derivation, because if we mix this in buildGoModule, the separate
  # go-modules build inherits specific attributes and fails. Getting that to
  # work is hackier than just splitting the build.
  ui = stdenv.mkDerivation {
    pname = "mailpit-ui";
    inherit src version;

    npmDeps = fetchNpmDeps {
      inherit src;
      hash = source.npmDepsHash;
    };

    # error "C++20 or later required." for dependency node_modules/tree-sitter
    env.NIX_CFLAGS_COMPILE = "-std=c++20";

    nativeBuildInputs = [
      nodejs
      python3
      libtool'
      npmHooks.npmConfigHook
    ];

    buildPhase = ''
      npm run package
    '';

    installPhase = ''
      mv server/ui/dist $out
    '';
  };

in

buildGoModule (finalAttrs: {
  pname = "mailpit";
  inherit src version vendorHash;

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X github.com/axllent/mailpit/config.Version=${version}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.passthru.ui} server/ui/dist
  '';

  passthru = {
    tests = {
      inherit (nixosTests) mailpit;
      # cannot use versionCheckHook due to the extra --no-release-check flag
      # for workarounds and other solutions see https://github.com/NixOS/nixpkgs/pull/486143#discussion_r2754533347
      version = testers.testVersion {
        package = mailpit;
        command = "mailpit version --no-release-check";
      };
    };

    updateScript = {
      supportedFeatures = [ "commit" ];
      command = ./update.sh;
    };

    inherit ui;
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/axllent/mailpit/releases/tag/v${version}";
    description = "Email and SMTP testing tool with API for developers";
    downloadPage = "https://github.com/axllent/mailpit";
    homepage = "https://mailpit.axllent.org";
    license = lib.licenses.mit;
    mainProgram = "mailpit";
    maintainers = with lib.maintainers; [
      stephank
      phanirithvij
    ];
  };
})
