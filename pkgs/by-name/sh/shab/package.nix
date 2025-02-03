{ bash, stdenv, lib, runCommand, writeText, fetchFromGitHub }:
let
  version = "1.0.0";

  shab = stdenv.mkDerivation {
    pname = "shab";
    inherit version;

    src = fetchFromGitHub {
      owner = "zimbatm";
      repo = "shab";
      rev = "v${version}";
      hash = "sha256-UW4tRZSir7KG7KXg0sOCd8kkIydEwZ6kdwxCeo0Ojgo=";
    };

    postPatch = ''
      for f in test.sh test/*.sh; do
        patchShebangs "$f"
      done
    '';

    doCheck = true;
    doInstallCheck = true;

    checkPhase = ''
      ./test.sh
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ./shab $out/bin/shab
    '';

    installCheckPhase = ''
      [[ "$(echo 'Hello $entity' | entity=world $out/bin/shab)" == 'Hello world' ]]
    '';

    passthru = {
      inherit render renderText;
    };

    meta = with lib; {
      description = "Bash templating language";
      mainProgram = "shab";
      homepage = "https://github.com/zimbatm/shab";
      license = licenses.unlicense;
      maintainers = with maintainers; [ zimbatm ];
      platforms = bash.meta.platforms;
    };
  };

  /*
     shabScript:       a path or filename to use as a template
     parameters.name:  the name to use as part of the store path
     parameters:       variables to expose to the template
   */
  render = shabScript: parameters:
    let extraParams = {
          inherit shabScript;
        };
    in runCommand "out" (parameters // extraParams) ''
      ${shab}/bin/shab "$shabScript" >$out
    '';

  /*
     shabScriptText:   a string to use as a template
     parameters.name:  the name to use as part of the store path
     parameters:       variables to expose to the template
   */
  renderText = shabScriptText: parameters:
    render (writeText "template" shabScriptText) parameters;

in
  shab
