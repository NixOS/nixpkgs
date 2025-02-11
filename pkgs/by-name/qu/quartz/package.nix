{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
}:

buildNpmPackage rec {
  pname = "quartz";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    rev = "v${version}";
    hash = "sha256-ImL9QycKNWnI7hFej6HeJra2flsdnrC+hoRrfW9kw2Q=";
  };

  # Hardcode the version instead of reading it from
  # package.json, that we don't want to carry around
  patches = [ ./dont-read-version-from-package-json.patch ];

  dontNpmBuild = true;

  # The deprecation notices breaks the CLI
  postFixup = ''
    makeWrapper ${nodejs}/bin/node $out/bin/quartz \
      --add-flags --no-deprecation \
      --add-flags $out/lib/node_modules/@jackyzha0/quartz/quartz/bootstrap-cli.mjs \
  '';

  npmDepsHash = "sha256-TAbNdOoYxLEzPxIOvECqu6IROW3PUW612K0cUm6/4aM=";

  meta = with lib; {
    description = "A fast static-site generator for Markdown content";
    mainProgram = "quartz";
    homepage = "https://github.com/jackyzha0/quartz/";
    changelog = "https://github.com/jackyzha0/quartz/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ julienmalka ];
  };

}
