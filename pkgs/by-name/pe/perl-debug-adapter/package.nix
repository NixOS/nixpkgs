{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  perl,
  # Needed if you want to use it for a perl script with dependencies.
  extraPerlPackages ? [ ],
}:

let
  perlInterpreter = perl.withPackages (
    ps:
    [
      ps.PadWalker
    ]
    ++ extraPerlPackages
  );
in
buildNpmPackage rec {
  pname = "perl-debug-adapter";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "Nihilus118";
    repo = "perl-debug-adapter";
    rev = version;
    hash = "sha256-IXXKhk4rzsWSPA0RT0L3CZuKlgTWtweZ4dQtruTigRs=";
  };

  npmDepsHash = "sha256-iw7+YC4qkrTVEJuZ9lnjNlUopTCp+fMNoIjFLutmrMw=";

  npmBuildScript = "compile";

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ perlInterpreter ])
  ];
  passthru = {
    inherit perlInterpreter;
  };

  meta = {
    description = "Debug adapter, invokes perl -d and handles communication with VS Code or other editors";
    homepage = "https://github.com/Nihilus118/perl-debug-adapter";
    changelog = "https://github.com/Nihilus118/perl-debug-adapter/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "perl-debug-adapter";
  };
}
