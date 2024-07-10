{
  buildDenoApplication,
  lib,
  fetchFromGitHub,
  ...
}:
buildDenoApplication rec {
  pname = "lesskey";
  version = "0.1.0-prealpha";

  src = fetchFromGitHub {
    owner = "AsPulse";
    repo = "lesskey";
    rev = "v${version}";
    hash = "sha256-SM6d8Bo6icz7i5CMzkZQwUh4zMu13RPJeI1Uq9bk8jY=";
  };
  mainScript = "src/index.ts";
  denoDepsHash = "sha256-ChBa2kJMqZFrelj7tJebEkmm40TZDX18h8NI3Rh1r9g=";
  denoJson = "deno.jsonc";
  denoLock = "deno.lock";

  meta = with lib; {
    description = "CLI client for misskey";
    homepage = "https://github.com/AsPulse/lesskey";
    license = licenses.mit;
    maintainers = [ maintainers.zebreus ];
  };
}
