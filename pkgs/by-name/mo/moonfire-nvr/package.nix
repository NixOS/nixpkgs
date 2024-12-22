{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  sqlite,
  testers,
  moonfire-nvr,
  darwin,
  nodejs,
  pnpm,
}:

let
  pname = "moonfire-nvr";
  version = "0.7.17";
  src = fetchFromGitHub {
    owner = "scottlamb";
    repo = "moonfire-nvr";
    rev = "refs/tags/v${version}";
    hash = "sha256-kh+SPM08pnVFxKSZ6Gb2LP7Wa8j0VopknZK2urMIFNk=";
  };
  ui = stdenv.mkDerivation (finalAttrs: {
    inherit version src;
    pname = "${pname}-ui";
    sourceRoot = "${src.name}/ui";
    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];
    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/ui";
      hash = "sha256-7fMhUFlV5lz+A9VG8IdWoc49C2CTdLYQlEgBSBqJvtw=";
    };
    installPhase = ''
      runHook preInstall

      cp -r public $out

      runHook postInstall
    '';
  });
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/server";

  useFetchCargoVendor = true;

  cargoHash = "sha256-fSzwA4R6Z/Awt52ZYhUvy2jhzrZiLU6IXTN8jvjmbTI=";

  env.VERSION = "v${version}";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      ncurses
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
      ]
    );

  postInstall = ''
    mkdir -p $out/lib/ui
    ln -s ${ui} $out/lib/ui
  '';

  doCheck = false;

  passthru = {
    inherit ui;
    tests.version = testers.testVersion {
      inherit version;
      package = moonfire-nvr;
      command = "moonfire-nvr --version";
    };
  };

  meta = {
    description = "Moonfire NVR, a security camera network video recorder";
    homepage = "https://github.com/scottlamb/moonfire-nvr";
    changelog = "https://github.com/scottlamb/moonfire-nvr/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "moonfire-nvr";
  };
}
