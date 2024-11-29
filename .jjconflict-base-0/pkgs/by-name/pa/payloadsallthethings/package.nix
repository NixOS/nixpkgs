{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "payloadsallthethings";
  version = "3.0-unstable-2024-01-21";

  src = fetchFromGitHub {
    owner = "swisskyrepo";
    repo = "PayloadsAllTheThings";
    rev = "97cfeee270395a838802fa1fcb8a4d5ffc6d6b48";
    hash = "sha256-LRS60v0o5nPSLfGFH6P0Y5roN8Mk5/KyRF4SWTv/7Hw=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/payloadsallthethings
    rm CONTRIBUTING.md mkdocs.yml custom.css
    cp -a * $out/share/payloadsallthethings
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/swisskyrepo/PayloadsAllTheThings";
    description = "List of useful payloads and bypass for Web Application Security and Pentest/CTF";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ shard7 ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
