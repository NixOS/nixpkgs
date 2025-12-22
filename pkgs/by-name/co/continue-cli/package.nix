{
  lib,
  stdenv,
  nodejs,
  fetchurl,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "continue-cli";
  version = "1.5.11";

  src = fetchurl {
    url = "https://registry.npmjs.org/@continuedev/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-mngKWY7LzekFqM+hRZAj/PbxlHzESnFM+6bMU2yOMF4=";
  };

  nativeBuildInputs = [ nodejs ];

  unpackPhase = ''
    mkdir -p $out/lib
    cd $out/lib
    tar -xzf $src
  '';

  installPhase = ''
    mkdir -p $out/lib/node_modules/@continuedev
    mv $out/lib/package $out/lib/node_modules/@continuedev/cli

    mkdir -p $out/bin
    cat > $out/bin/cn <<EOF
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/node_modules/@continuedev/cli/dist/cn.js "\$@"
    EOF

    chmod +x $out/bin/cn
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Continue CLI";
    homepage = "https://continue.dev";
    changelog = "https://changelog.continue.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ MiyakoMeow ];
    mainProgram = "cn";
    platforms = lib.platforms.all;
  };
})
