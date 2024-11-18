{
  lib,
  stdenv,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  sqlite,
  testers,
  moonfire-nvr,
  darwin,
}:

let
  pname = "moonfire-nvr";
  version = "0.7.7";
  src = fetchFromGitHub {
    owner = "scottlamb";
    repo = "moonfire-nvr";
    rev = "v${version}";
    hash = "sha256-+7VahlS+NgaO2knP+xqdlZnNEfjz8yyF/VmjWf77KXI=";
  };
  ui = buildNpmPackage {
    inherit version src;
    pname = "${pname}-ui";
    sourceRoot = "${src.name}/ui";
    npmDepsHash = "sha256-IpZWgMo6Y3vRn9h495ifMB3tQxobLeTLC0xXS1vrKLA=";
    installPhase = ''
      runHook preInstall

      cp -r build $out

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  sourceRoot = "${src.name}/server";

  useFetchCargoVendor = true;
  cargoHash = "sha256-qQyeOQhor3erqLZ66HRsdCP/+DdoVWDfs51SmW0GujE=";

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

  meta = with lib; {
    description = "Moonfire NVR, a security camera network video recorder";
    homepage = "https://github.com/scottlamb/moonfire-nvr";
    changelog = "https://github.com/scottlamb/moonfire-nvr/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "moonfire-nvr";
  };
}
