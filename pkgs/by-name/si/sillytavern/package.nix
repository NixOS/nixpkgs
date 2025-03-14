{
  bubblewrap,
  runtimeShell,
  buildNpmPackage,
  nodejs,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "sillytavern";
  version = "1.12.10";
  src = fetchFromGitHub {
    owner = "SillyTavern";
    repo = "SillyTavern";
    tag = version;
    hash = "sha256-eCGDqG0dLCkOPfSunzdskE9PbmXnii96X10KwIMUaeY=";
  };
  npmDepsHash = "sha256-KwPzpw85bCBfobARIlyaX4r0rRh3SlaGE7rNlPEvD6A=";
  dontNpmBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,app}
    cp -r . $out/app/sillytavern
    cat > $out/bin/sillytavern <<- EOF
    #!${runtimeShell}

    export NODE_ENV=production

    ${bubblewrap}/bin/bwrap \
      --dev-bind / / \
      --bind $out/app/sillytavern/default \$PWD/default \
      ${nodejs}/bin/node $out/app/sillytavern/server.js \$@
    EOF

    chmod 755 $out/bin/sillytavern

    runHook postInstall
  '';

  meta = {
    description = "LLM Frontend for Power Users";
    longDescription = ''
      SillyTavern is a user interface you can install on your computer (and Android phones) that allows you to interact with
      text generation AIs and chat/roleplay with characters you or the community create.
    '';
    downloadPage = "https://github.com/SillyTavern/SillyTavern/releases";
    homepage = "https://docs.sillytavern.app/";
    mainProgram = "sillytavern";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.wrvsrx ];
  };
}
