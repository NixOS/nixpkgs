{
  python3Packages,
  lib,
}:

python3Packages.buildPythonApplication {
  pname = "mrs-update-script";
  version = "1.0.0";

  src = ./.;

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.beautifulsoup4 ];

  meta = {
    description = "Updater for Mothers Ruin Software packages";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "mrs-update-script";
    platforms = lib.platforms.unix;
  };
}
