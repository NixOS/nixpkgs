{
  buildNpmPackage,
  fetchFromGitHub,
  inter,
  nixosTests,
  lib,
  # This is a app can only be used in a browser and starts a web server only accessible at
  # localhost/127.0.0.1 from the local computer at the given port.
  defaultHostname ? "127.0.0.1",
  defaultPort ? 3000,
  # Where to find the Ollama service; this url gets baked into the Nix package
  ollamaUrl ? "http://127.0.0.1:11434",
}:

let
  version = "1.2.0";
  tag = "v.${version}";
in
buildNpmPackage {
  pname = "nextjs-ollama-llm-ui";
  inherit version;

  src = fetchFromGitHub {
    owner = "jakobhoeg";
    repo = "nextjs-ollama-llm-ui";
    inherit tag;
    hash = "sha256-hgLeTWtnyxGMkMsAGBbaM2yeS/H8AStMPR2bjLdjwEc=";
  };
  npmDepsHash = "sha256-9+A+85IK4zmMGlBsVoLg7RnST72AhAM6xPGnBZLgLTk=";

  patches = [
    # nextjs tries to download google fonts from the internet during buildPhase and fails in Nix sandbox.
    # We patch the code to expect a local font from src/app/Inter.ttf that we load from Nixpkgs in preBuild phase.
    ./0002-use-local-google-fonts.patch
  ];

  # Adjust buildNpmPackage phases with nextjs quirk workarounds.
  # These are adapted from
  # https://github.com/NixOS/nixpkgs/blob/485125d667747f971cfcd1a1cfb4b2213a700c79/pkgs/servers/homepage-dashboard/default.nix
  #######################3
  preBuild = ''
    # We have to pass and bake in the Ollama URL into the package
    echo "NEXT_PUBLIC_OLLAMA_URL=${ollamaUrl}" > .env

    # Replace the googleapis.com Inter font with a local copy from nixpkgs
    cp "${inter}/share/fonts/truetype/InterVariable.ttf" src/app/Inter.ttf
  '';

  postBuild = ''
    # Add a shebang to the server js file, then patch the shebang to use a nixpkgs nodejs binary.
    sed -i '1s|^|#!/usr/bin/env node\n|' .next/standalone/server.js
    patchShebangs .next/standalone/server.js
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share,bin}

    cp -r .next/standalone $out/share/homepage/
    cp -r .env $out/share/homepage/
    cp -r public $out/share/homepage/public

    mkdir -p $out/share/homepage/.next
    cp -r .next/static $out/share/homepage/.next/static

    # https://github.com/vercel/next.js/discussions/58864
    ln -s /var/cache/nextjs-ollama-llm-ui $out/share/homepage/.next/cache
    # also provide a environment variable to override the cache directory
    substituteInPlace $out/share/homepage/node_modules/next/dist/server/image-optimizer.js \
        --replace '_path.join)(distDir,' '_path.join)(process.env["NEXT_CACHE_DIR"] || distDir,'

    chmod +x $out/share/homepage/server.js

    # we set a default port to support "nix run ..."
    makeWrapper $out/share/homepage/server.js $out/bin/nextjs-ollama-llm-ui \
      --set-default PORT ${toString defaultPort} \
      --set-default HOSTNAME ${defaultHostname}

    runHook postInstall
  '';

  doDist = false;
  #######################

  passthru = {
    tests = {
      inherit (nixosTests) nextjs-ollama-llm-ui;
    };
  };

  meta = {
    description = "Simple chat web interface for Ollama LLMs";
    changelog = "https://github.com/jakobhoeg/nextjs-ollama-llm-ui/releases/tag/${tag}";
    mainProgram = "nextjs-ollama-llm-ui";
    homepage = "https://github.com/jakobhoeg/nextjs-ollama-llm-ui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malteneuss ];
    platforms = lib.platforms.all;
  };
}
