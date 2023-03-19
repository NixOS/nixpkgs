{ bun, lib, stdenv, makeWrapper, runCommand, nix-update }:

{ vendorSha256 ? "", name ? "${args'.pname}-${args'.version}", buildInputs ? [ ]
, nativeBuildInputs ? [ ], prod ? true, bunlock ? (args'.src + "/bun.lockb")
, src, ... }@args':

with builtins;

let
  cleanSourceFilter = name: type:
    let baseName = baseNameOf (toString name);
    in lib.cleanSourceFilter name type
    && !(baseName == "node_modules" || baseName == "node_modules.bun");
  args = removeAttrs args' [ "overrideModAttrs" "vendorSha256" "prod" "src" ];
  node_modules = stdenv.mkDerivation ({
    name = "${name}-node_modules";
    impureEnvVars = lib.fetchers.proxyImpureEnvVars
      ++ [ "GIT_PROXY_COMMAND" "SOCKS_SERVER" ];
    srcs = [ (args'.src + "/package.json") bunlock ];
    nativeBuildInputs = nativeBuildInputs ++ [ bun ];
    unpackPhase = ''
      for _src in $srcs; do
        file=$(stripHash "$_src")
        cp "$_src" $file
        chmod 644 $file
      done
    '';
    dontConfigure = true;
    buildPhase = ''
      bun install --no-progress ${if prod then "--production" else ""}
    '';
    installPhase = ''
      cp -R ./node_modules $out
    '';
  } // (if stringLength vendorSha256 > 0 then {
    outputHash = vendorSha256;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  } else
    { }));
in stdenv.mkDerivation (args // {
  src = lib.cleanSourceWith {
    filter = cleanSourceFilter;
    src = args'.src;
  };
  nativeBuildInputs = nativeBuildInputs ++ [ makeWrapper ];
  buildInputs = buildInputs ++ [ bun ];
  dontConfigure = true;
  npmDeps = node_modules;
  installPhase = ''
    output=$out/opt/${args'.pname}
    mkdir -p $output
    cp -r . $output
    ln -s ${node_modules} $output/node_modules
    mkdir -p $out/bin
    makeWrapper ${bun}/bin/bun $out/bin/${args'.pname} --add-flags "run --cwd $output" \
                --set PATH "$output/node_modules/.bin:${bun}/bin"
  '';
})
