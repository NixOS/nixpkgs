{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (final: {
  pname = "curlconverter";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "curlconverter";
    repo = "curlconverter";
    tag = "v${final.version}";
    hash = "sha256-eJ8D5HkYSkWqQt/4UTv6/X6coLwcODde6xGEPQXgJRo=";
  };

  npmDepsHash = "sha256-UIbMvw8hkZxtSGInV2+Fjm4DZahrdGtSxi0Unhb5lh8=";

  # Prevent the dependency tree-sitter-cli from running its install script, which has an impure network request: https://github.com/tree-sitter/tree-sitter/blob/fd77bda97a0ca05d124590833312e4103f985543/crates/cli/npm/install.js#L63
  npmFlags = [ "--ignore-scripts" ];

  npmBuildScript = "compile";

  meta = {
    description = "Convert curl commands to Python, JavaScript and more";
    homepage = "https://curlconverter.com/";
    license = lib.licenses.mit;
    mainProgram = "curlconverter";
    maintainers = with lib.maintainers; [ jiamingc ];
  };
})
