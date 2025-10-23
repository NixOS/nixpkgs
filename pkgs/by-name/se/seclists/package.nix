{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "seclists";
  version = "2025.3";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "SecLists";
    rev = "2025.3";
    hash = "sha256-o4Va+OJCrDwHhmuN3HbURAOhPLCJGHnJW7RcOkaYPOQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wordlists/seclists
    find . -maxdepth 1 -type d -regextype posix-extended -regex '^./[A-Z].*' -exec cp -R {} $out/share/wordlists/seclists \;
    find $out/share/wordlists/seclists -name "*.md" -delete

    runHook postInstall
  '';

  meta = with lib; {
    description = "Collection of multiple types of lists used during security assessments, collected in one place";
    homepage = "https://github.com/danielmiessler/seclists";
    license = licenses.mit;
    maintainers = with maintainers; [
      tochiaha
      pamplemousse
    ];
  };
}
