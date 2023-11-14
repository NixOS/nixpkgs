{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "seclists";
  version = "2023.2";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "SecLists";
    rev = "2023.2";
    hash = "sha256-yVxb5GaQDuCsyjIV+oZzNUEFoq6gMPeaIeQviwGdAgY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wordlists/seclists
    find . -maxdepth 1 -type d -regextype posix-extended -regex '^./[A-Z].*' -exec cp -R {} $out/share/wordlists/seclists \;
    find $out/share/wordlists/seclists -name "*.md" -delete

    runHook postInstall
  '';

  meta = with lib; {
    description = "A collection of multiple types of lists used during security assessments, collected in one place";
    homepage = "https://github.com/danielmiessler/seclists";
    license = licenses.mit;
    maintainers = with maintainers; [ tochiaha janik pamplemousse ];
  };
}

