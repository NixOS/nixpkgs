{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "i18next-cli";
  version = "1.67.3";

  src = fetchFromGitHub {
    owner = "i18next";
    repo = "i18next-cli";
    tag = "v${version}";
    hash = "sha256-4Fs6u2H0C7Za+UdCP3W9D3o1H2NMbXuuea/jnfnM4wU=";
  };

  # NOTE: Generating lock-file
  # npm install --package-lock-only
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-BzRzy2dBdIYKVgEeJfdiQwzm4lsvR4wUcJWCI62sJXQ=";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    description = "A unified, high-performance i18next CLI";
    changelog = "https://github.com/i18next/i18next-cli/blob/v${version}/CHANGELOG.md";
    homepage = "https://www.locize.com/blog/i18next-cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pbek ];
    mainProgram = "i18next-cli";
  };
}
