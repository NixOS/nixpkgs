{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
  runCommand,
  dieHook,
  nixosTests,
  testers,
  scaphandre,
}:

rustPlatform.buildRustPackage rec {
  pname = "scaphandre";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hubblo-org";
    repo = "scaphandre";
    rev = "v${version}";
    hash = "sha256-I+cECdpLoIj4yuWXfirwHlcn0Hkm9NxPqo/EqFiBObw=";
  };

  cargoHash = "sha256-OIoQ2r/T0ZglF1pe25ND8xe/BEWgP9JbWytJp4k7yyg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  checkPhase = ''
    runHook preCheck

    # Work around to pass test due to non existing path
    # https://github.com/hubblo-org/scaphandre/blob/v1.0.2/src/sensors/powercap_rapl.rs#L29
    export SCAPHANDRE_POWERCAP_PATH="$(mktemp -d)/scaphandre"

    mkdir -p "$SCAPHANDRE_POWERCAP_PATH"

    runHook postCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      stdout =
        self:
        runCommand "${pname}-test"
          {
            buildInputs = [
              self
              dieHook
            ];
          }
          ''
            ${self}/bin/scaphandre stdout -t 4 > $out  || die "Scaphandre failed to measure consumption"
            [ -s $out ]
          '';
      vm = nixosTests.scaphandre;
      version = testers.testVersion {
        inherit version;
        package = scaphandre;
        command = "scaphandre --version";
      };
    };
  };

  meta = with lib; {
    description = "Electrical power consumption metrology agent";
    homepage = "https://github.com/hubblo-org/scaphandre";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "scaphandre";
    # Upstream needs to decide what to do about a broken dependency
    # https://github.com/hubblo-org/scaphandre/issues/403
    broken = true;
  };
}
