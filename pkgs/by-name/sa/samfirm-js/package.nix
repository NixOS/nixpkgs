{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "samfirm-js";
  version = "0.3.0+git5e2537c";

  src = fetchFromGitHub {
    owner = "DavidArsene";
    repo = "samfirm.js";
    rev = "5e2537c2452c3033259a1e4399d9bb755e99f1da";
    hash = "sha256-81nWdIXJMXy5P37K9A3hAdLrYAEtqPJy7baM1Z22tzs=";
  };

  npmDepsHash = "sha256-os75tFpyxzxGpt5Era+K+zgMJyfwD4u0AtTRLC/fPUQ=";

  installPhase = "install -Dm555 dist/index.js $out/bin/samfirm-js";

  meta = with lib; {
    description = "Program for downloading Samsung firmware";
    homepage = "https://github.com/DavidArsene/samfirm.js";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ungeskriptet ];
    mainProgram = "samfirm-js";
  };
}
