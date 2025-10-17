{
  lib,
  stdenv,
  perlPackages,
  fetchFromGitHub,
  shortenPerlShebang,
  nix-update-script,
}:

perlPackages.buildPerlPackage rec {
  pname = "pgformatter";
  version = "5.8";

  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgFormatter";
    rev = "v${version}";
    hash = "sha256-m9xVzov0KtWLfC+24YBiE7UFaLqpwpzOyXpjMPHuito=";
  };

  outputs = [ "out" ];

  makeMakerFlags = [ "INSTALLDIRS=vendor" ];

  # Avoid creating perllocal.pod, which contains a timestamp
  installTargets = [ "pure_install" ];

  # Makefile.PL only accepts DESTDIR and INSTALLDIRS, but we need to set more to make this work for NixOS.
  patchPhase = ''
    substituteInPlace pg_format \
      --replace "#!/usr/bin/env perl" "#!/usr/bin/perl"
    substituteInPlace Makefile.PL \
      --replace "'DESTDIR'      => \$DESTDIR," "'DESTDIR'      => '$out/'," \
      --replace "'INSTALLDIRS'  => \$INSTALLDIRS," "'INSTALLDIRS'  => \$INSTALLDIRS, 'INSTALLVENDORLIB' => 'bin/lib', 'INSTALLVENDORBIN' => 'bin', 'INSTALLVENDORSCRIPT' => 'bin', 'INSTALLVENDORMAN1DIR' => 'share/man/man1', 'INSTALLVENDORMAN3DIR' => 'share/man/man3',"
  '';

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang $out/bin/pg_format
  '';

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PostgreSQL SQL syntax beautifier that can work as a console program or as a CGI";
    homepage = "https://github.com/darold/pgFormatter";
    changelog = "https://github.com/darold/pgFormatter/releases/tag/v${version}";
    maintainers = [ ];
    license = [
      lib.licenses.postgresql
      lib.licenses.artistic2
    ];
    mainProgram = "pg_format";
  };
}
