{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "resumed";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "rbardini";
    repo = "resumed";
    rev = "v${version}";
    hash = "sha256-X1efWl0CjbEbhNfDUNvb5SCc2exfI8v95gzqcaKU5eU=";
  };

  npmDepsHash = "sha256-b8NeO0w2UH1wEifDCkl8L48LoJM0jLStE0fO9G438dU=";

  meta = with lib; {
    description = "Lightweight JSON Resume builder, no-frills alternative to resume-cli";
    homepage = "https://github.com/rbardini/resumed";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
    mainProgram = "resumed";
  };
}
