{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
  pcsclite,
  pkg-config,
  stdenv,
  tailwindcss_4,
  templ,
  uglify-js,
}:

let
  src = fetchFromGitHub {
    owner = "foks-proj";
    repo = "go-foks";
    tag = "v${version}";
    hash = "sha256-N4sWxYnHeqvG/qcqoqakUbxjtoh8CNPegYPYdrgP+z4=";
  };
  version = "0.1.1";
  templFoks = templ.overrideAttrs (old: {
    pname = "templ-foks";
    version = "0.3.833";
    src = old.src.override {
      hash = "sha256-4K1MpsM3OuamXRYOllDsxxgpMRseFGviC4RJzNA7Cu8=";
    };
    vendorHash = "sha256-OPADot7Lkn9IBjFCfbrqs3es3F6QnWNjSOHxONjG4MM=";
  });
  foksNodeModules = buildNpmPackage {
    pname = "foks-node-modules";
    inherit version src;
    npmDepsHash = "sha256-mASu3taprCYP+muRh4b+qUTce7YTdISf/QnmSvUy6Mo=";
    dontNpmBuild = true;
    sourceRoot = "${src.name}/server/web/frontend";
    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out/node_modules
    '';
  };
in
buildGoModule (finalAttrs: {
  pname = "foks-server";
  inherit version src;

  vendorHash = "sha256-8/SVOWMoCfeiuH2As2cC/HLRs1WQIQ4/Ko1olXDq6bo=";

  postPatch = ''
    # Generate templates
    cd ./server/web/templates
    ${templFoks}/bin/templ generate
    cd -
    # Generate tailwind
    cd ./server/web/frontend
    mkdir -p ../static/css
    ${tailwindcss_4}/bin/tailwindcss -i ./css/input.css -o ../static/css/style.min.css --minify
    ${tailwindcss_4}/bin/tailwindcss -i ./css/input.css -o ../static/css/style.css
    ${uglify-js}/bin/uglifyjs -c < ../static/js/foks.js > ../static/js/foks.min.js
    cd -
    # Copy htmx dependency from node modules
    cd ./server/web/static
    mkdir -p ./js
    cp ${foksNodeModules}/node_modules/htmx.org/dist/htmx.js ./js/htmx.js
    cp ${foksNodeModules}/node_modules/htmx.org/dist/htmx.min.js ./js/htmx.min.js
    cd -
  '';
  subPackages = [
    "server/foks-server"
    "server/foks-tool"
  ];
  excludedPackages = [ "client" ];

  buildInputs = lib.optionals (stdenv.hostPlatform.isLinux) [ pcsclite ];
  nativeBuildInputs = [
    pkg-config
  ];
  ldflags = [
    "-X main.LinkerVersion=v${finalAttrs.version}"
  ];

  meta = {
    description = "Federated key management and distribution system";
    homepage = "https://foks.pub";
    downloadPage = "https://github.com/foks-proj/go-foks";
    changelog = "https://github.com/foks-proj/go-foks/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ poptart ];
    mainProgram = "foks-server";
  };
})
