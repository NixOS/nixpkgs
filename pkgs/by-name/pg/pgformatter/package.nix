{
  lib,
  perlPackages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

perlPackages.buildPerlPackage rec {
  pname = "pgformatter";
  version = "5.10";

  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgFormatter";
    tag = "v${version}";
    hash = "sha256-OWw47okAs8x4Ri8+IJHPhy6YSkSN2sBlJ0v8h6GlhfU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  outputs = [ "out" ];

  makeMakerFlags = [ "INSTALLDIRS=vendor" ];

  # Avoid creating perllocal.pod, which contains a timestamp
  installTargets = [ "pure_install" ];

  # Makefile.PL only accepts DESTDIR and INSTALLDIRS, but we need to set more to make this work for NixOS.
  postPatch = ''
    substituteInPlace pg_format \
      --replace-fail "#!/usr/bin/env perl" "#!/usr/bin/perl"

    substituteInPlace Makefile.PL \
      --replace-fail \
        "'DESTDIR'      => \$DESTDIR," \
        "'DESTDIR'      => '$out/'," \
      --replace-fail \
        "'INSTALLDIRS'  => \$INSTALLDIRS," \
        "'INSTALLDIRS'  => \$INSTALLDIRS, 'INSTALLVENDORLIB' => 'bin/lib', 'INSTALLVENDORBIN' => 'bin', 'INSTALLVENDORSCRIPT' => 'bin', 'INSTALLVENDORMAN1DIR' => 'share/man/man1', 'INSTALLVENDORMAN3DIR' => 'share/man/man3',"

    patchShebangs .
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PostgreSQL SQL syntax beautifier that can work as a console program or as a CGI";
    homepage = "https://github.com/darold/pgFormatter";
    changelog = "https://github.com/darold/pgFormatter/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [
      thunze
      mfairley
    ];
    license =
      with lib.licenses;
      AND [
        postgresql
        artistic2
      ];
    mainProgram = "pg_format";
  };
}
