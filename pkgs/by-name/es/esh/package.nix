{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoctor,
  gawk,
  gnused,
  coreutils,
  runtimeShell,
  binlore,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "esh";
  version = "0.1.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "esh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3EhavdwqyHw9GFtCxzDzSrZSkZcY5vm2b8HRa0uUqrU=";
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
    patchShebangs .
    substituteInPlace esh \
        --replace-fail '"/bin/sh"' '"${runtimeShell}"' \
        --replace-fail '"awk"' '"${gawk}/bin/awk"' \
        --replace-fail 'sed' '${gnused}/bin/sed' \
        --replace-fail 'cat' '${coreutils}/bin/cat'
    substituteInPlace tests/test-dump.exp \
        --replace-fail '#!/bin/sh' '#!${runtimeShell}'
  '';

  doCheck = true;
  checkTarget = "test";

  # working around a bug in file. Was fixed in
  # file 5.41-5.43 but regressed in 5.44+
  # see https://bugs.astron.com/view.php?id=276
  # "can" verdict because of `-s SHELL` arg
  passthru.binlore.out = binlore.synthesize finalAttrs.finalPackage ''
    execer can bin/esh
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  meta = {
    description = "Simple templating engine based on shell";
    mainProgram = "esh";
    homepage = "https://github.com/jirutka/esh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mnacamura ];
    platforms = lib.platforms.unix;
  };
})
