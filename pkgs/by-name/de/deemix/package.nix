{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_20,
  pnpm_9,
  cacert,
  turbo,
  runtimeShell,
  ...
}:
let
  pnpm = pnpm_9;
  nodejs = nodejs_20;
  pname = "deemix";
  version = "4.3.0";
  src = fetchFromGitHub {
    owner = "bambanah";
    repo = "deemix";
    tag = "deemix-webui@${version}";
    hash = "sha256-OIMOupciEoj3CAblEAxfX5awjKySYPtvLfnzrUcIjzY=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    cacert
    turbo
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-7CEBFv85SngWekWhbKQhRRL7P/Llf6fQ3JSyu5+2SDc=";
  };

  buildPhase = ''
    runHook preBuild
    turbo prune deemix-webui --docker
    mkdir builder
    cp -r out/json/* builder
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    pushd builder
    pnpm install --frozen-lockfile
    cp -r ../out/full/* .
    pnpm turbo build --filter=deemix-webui...
    popd
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    rm -r $(find -type d -name .turbo)
    cp -r builder/* $out/
    cat <<EOF > $out/bin/deemix
    #!${runtimeShell}
    exec ${nodejs}/bin/node $out/webui/dist/main.js
    EOF
    chmod +x $out/bin/deemix
  '';

  meta = {
    description = "Deemix is a tool that facilitates downloading music from Deezer";
    homepage = "https://github.com/bambanah/deemix";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      notthebee
    ];
    mainProgram = "deemix";
    platforms = lib.platforms.unix;
  };

})
