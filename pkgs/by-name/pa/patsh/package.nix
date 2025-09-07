{
  lib,
  runCommand,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  coreutils,
}:

let
  # copied from flake.nix
  # tests require extra setup with nix
  custom = runCommand "custom" { } ''
    mkdir -p $out/bin
    touch $out/bin/{'foo$','foo"`'}
    chmod +x $out/bin/{'foo$','foo"`'}
  '';
in

rustPlatform.buildRustPackage rec {
  pname = "patsh";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "patsh";
    rev = "v${version}";
    sha256 = "sha256-d2Br4RAlKO7Bpse8sFbIDCIYd2fYvby0ar9oIbQS2jc=";
  };

  cargoHash = "sha256-wJDWJFutOvAVou4IpAunrHnUgYmodDliqrmPUai8pVo=";

  nativeCheckInputs = [ custom ];

  # see comment on `custom`
  postPatch = ''
    for file in tests/fixtures/*-expected.sh; do
      substituteInPlace $file \
        --subst-var-by cc ${stdenv.cc} \
        --subst-var-by coreutils ${coreutils} \
        --subst-var-by custom ${custom}
    done
  '';

  meta = {
    description = "Command-line tool for patching shell scripts inspired by resholve";
    mainProgram = "patsh";
    homepage = "https://github.com/nix-community/patsh";
    changelog = "https://github.com/nix-community/patsh/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
