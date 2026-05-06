{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoctor,
  gawk,
  gnused,
  runtimeShell,
  binlore,
  esh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "esh";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "esh";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-suwbUT8miOYMdTMw+vJm2URiDInhEczn0JG9K5KpEto=";
  };

  nativeBuildInputs = [ asciidoctor ];

  buildInputs = [
    gawk
    gnused
  ];

  makeFlags = [
    "prefix=$(out)"
    "DESTDIR="
  ];

  postPatch = ''
    patchShebangs esh
    patchShebangs tests/*.t
    patchShebangs tests/run-tests
    patchShebangs tests/diff-test
    rm tests/test-eval-error-nested.*
    rm tests/test-eval-error.*
    substituteInPlace tests/run-tests \
        --replace-fail 'set -eu' "set -eu;export ESH_SHELL=${runtimeShell}"
    substituteInPlace esh \
        --replace-fail '"/bin/sh"' '"${runtimeShell}"' \
        --replace-fail '"awk"' '"${gawk}/bin/awk"' \
        --replace-fail 'sed -' '${gnused}/bin/sed -'
    substituteInPlace tests/test-cli-no-args.exp2 \
        --replace-fail '"/bin/sh"' '"${runtimeShell}"' \
        --replace-fail '"awk"' '"${gawk}/bin/awk"'
    substituteInPlace tests/test-cli-help.exp \
        --replace-fail '"/bin/sh"' '"${runtimeShell}"' \
        --replace-fail '"awk"' '"${gawk}/bin/awk"'
    substituteInPlace tests/test-cli-dump.exp \
        --replace-fail '!/bin/sh' '!${runtimeShell}'
  '';

  doCheck = true;
  checkTarget = "test";

  # working around a bug in file. Was fixed in
  # file 5.41-5.43 but regressed in 5.44+
  # see https://bugs.astron.com/view.php?id=276
  # "can" verdict because of `-s SHELL` arg
  passthru.binlore.out = binlore.synthesize esh ''
    execer can bin/esh
  '';

  meta = {
    description = "Simple templating engine based on shell";
    mainProgram = "esh";
    homepage = "https://github.com/jirutka/esh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mnacamura ];
    platforms = lib.platforms.unix;
  };
})
