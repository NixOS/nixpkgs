{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs_20,
}:

buildNpmPackage (finalAttrs: {
  pname = "scanservjs";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "sbs20";
    repo = "scanservjs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qCJyQO/hSDF4NOupV7sepwvpNyjSElnqT71LJuIKe+A=";
  };

  npmDepsHash = "sha256-HIWT09G8gqSFt9CIjsjJaDRnj2GO0G6JOGeI0p4/1vw=";

  # Build fails on node 22, presumably because of esm.
  # https://github.com/NixOS/nixpkgs/issues/371649
  nodejs = nodejs_20;

  patches = [
    ./nix-compatibility.patch
  ];

  postBuild = ''
    # Install runtime dependencies
    npm install \
      --prefix ./dist \
      --offline \
      --production \
      --ignore-scripts
  '';

  installPhase = ''
    runHook preInstall

    rm -rf $out/lib

    mkdir -p $out/lib
    cp -r dist/* $out/lib

    substituteInPlace $out/lib/server/express-configurer.js \
      --replace-fail "@client@" "$out/lib/client"

    mkdir -p $out/bin
    makeWrapper ${lib.getExe finalAttrs.nodejs} $out/bin/scanservjs \
      --set NODE_ENV production \
      --add-flags "$out/lib/server/server.js"

    runHook postInstall
  '';

  meta = {
    description = "SANE scanner nodejs web ui";
    longDescription = "scanservjs is a simple web-based UI for SANE which allows you to share a scanner on a network without the need for drivers or complicated installation.";
    homepage = "https://github.com/sbs20/scanservjs";
    license = lib.licenses.gpl2Only;
    mainProgram = "scanservjs";
    maintainers = with lib.maintainers; [ chayleaf ];
    platforms = lib.platforms.linux;
  };
})
