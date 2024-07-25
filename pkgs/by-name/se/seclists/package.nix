{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  archiveExtract ? [ ],
  unzip,
}:

let
  pname = "seclists";
  archiveExtractList = [
    "true"
    "false"
  ];
in
lib.checkListOfEnum "${pname}: archiveExtract" archiveExtractList archiveExtract

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "2024.2";

    src = fetchFromGitHub {
      owner = "danielmiessler";
      repo = "SecLists";
      rev = "2024.2";
      hash = "sha256-qqXOLuZOj+mF7kXrdO62HZTrGsyepOSWr5v6j4WFGcc=";
    };

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/wordlists/seclists
      ${lib.optionalString (archiveExtract == [ "true" ]) ''
        DIRS=(
            "./Passwords/Leaked-Databases"
            "./Payloads"
            "./Miscellaneous"
        )
        for DIR in "''${DIRS[@]}"; do
          for file in "$DIR"/*.{tar.gz,zip}; do
            echo "File $file"
            if [[ -f "$file" ]]; then
              case "$file" in
                *.tar.gz)
                  tar -zxvf "$file" -C "$DIR"
                  ;;
                *.zip)
                  unzip "$file" -d "$DIR"
                  ;;
              esac
              rm "$file"
            fi
          done
        done
      ''}
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
        d3vil0p3r
      ];
    };
  }
