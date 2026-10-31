{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "17.16.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-PKOmPhDQpY63//gVLjt81Zvb9aNKW63l7dyTYfq5xQc=";
  };

  npmDepsHash = "sha256-6QXOKwMxXy5+ncl0R3ATFmo59974Wc+ZU4mvr1DIO1g=";

  npmFlags = [ "--legacy-peer-deps" ];

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
