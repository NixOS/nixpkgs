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
    "phpinfo"
    "rockyou"
    "rockyou-withcount"
    "top-domains-alexa"
    "top-domains-majestic"
    "all"
  ];
in
lib.checkListOfEnum "${pname}: archiveExtract" archiveExtractList archiveExtract

  stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname;
    version = "2024.3";

    src = fetchFromGitHub {
      owner = "danielmiessler";
      repo = "SecLists";
      rev = "${finalAttrs.version}";
      hash = "sha256-Ffd4jpV8F6rtMQVqsu+8X/QU5rwbKXv0zkOCmUuhP8I=";
    };

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/wordlists/seclists
      ${lib.optionalString (lib.elem "phpinfo" archiveExtract) ''
        unzip "Payloads/PHPInfo.zip" -d "./Payloads"
        rm "./Payloads/PHPInfo.zip"
      ''}

      ${lib.optionalString (lib.elem "rockyou" archiveExtract) ''
        tar -zxvf "Passwords/Leaked-Databases/rockyou.txt.tar.gz" -C "./Passwords/Leaked-Databases"
        rm "./Passwords/Leaked-Databases/rockyou.txt.tar.gz"
      ''}

      ${lib.optionalString (lib.elem "rockyou-withcount" archiveExtract) ''
        tar -zxvf "Passwords/Leaked-Databases/rockyou-withcount.txt.tar.gz" -C "./Passwords/Leaked-Databases"
        rm "./Passwords/Leaked-Databases/rockyou-withcount.txt.tar.gz"
      ''}

      ${lib.optionalString (lib.elem "top-domains-alexa" archiveExtract) ''
        unzip "Miscellaneous/top-domains-alexa.csv.zip" -d "./Miscellaneous"
        rm "Miscellaneous/top-domains-alexa.csv.zip"
      ''}

      ${lib.optionalString (lib.elem "top-domains-majestic" archiveExtract) ''
        unzip "Miscellaneous/top-domains-majestic.csv.zip" -d "./Miscellaneous"
        rm "Miscellaneous/top-domains-majestic.csv.zip"
      ''}

      ${lib.optionalString (archiveExtract == [ "all" ]) ''
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

    meta = {
      description = "Collection of multiple types of lists used during security assessments, collected in one place";
      homepage = "https://github.com/danielmiessler/seclists";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        tochiaha
        pamplemousse
        d3vil0p3r
      ];
    };
  })
