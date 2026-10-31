{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  callPackage,
  makeWrapper,
  nodejs_22,
  nixosTests,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "musivault";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "Jeanball";
    repo = "Musivault";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TqTxxCFlsH/ew8kWh/Yn32C45PAPjN2LhyuD++6gV+Y=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;

  backendNpmDepsHash = "sha256-bTUqPED9gI56LzHpMqKz2jEtBlEKeVBdQ+YVeN3YKrI=";
  frontendNpmDepsHash = "sha256-pLKdZNuABtQK6+GWf7sCezCPZFpofG9YCE18tA846CE=";

  backend = callPackage ./backend.nix {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    npmDepsHash = finalAttrs.backendNpmDepsHash;
  };

  frontend = callPackage ./frontend.nix {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    npmDepsHash = finalAttrs.frontendNpmDepsHash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt $out/bin $out/share/musivault
    cp -r ${finalAttrs.backend}/opt/* $out/opt/
    cp -r ${finalAttrs.frontend}/share/musivault/* $out/share/musivault/

    # The backend resolves uploads and logs relative to __dirname (opt/dist/).
    # Symlink them to the state directory so writes go to a writable location.
    ln -s /var/lib/musivault/uploads $out/opt/uploads
    ln -s /var/lib/musivault/logs $out/opt/logs

    makeWrapper ${nodejs_22}/bin/node $out/bin/musivault \
      --add-flags "$out/opt/dist/server.js" \
      --set NODE_ENV production

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) musivault;
    };
  };

  meta = {
    description = "Web application to catalog and explore your vinyl and CD collection";
    homepage = "https://github.com/Jeanball/Musivault";
    changelog = "https://github.com/Jeanball/Musivault/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "musivault";
    maintainers = with lib.maintainers; [ tomhesse ];
    platforms = lib.platforms.linux;
  };
})
