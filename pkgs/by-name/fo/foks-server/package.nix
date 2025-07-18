{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildNpmPackage,
  pcsclite,
  pkg-config,
  nix-update-script,
  stdenv,
  tailwindcss_4,
  templ,
  uglify-js,
  versionCheckHook,
}:

let
  src = fetchFromGitHub {
    owner = "foks-proj";
    repo = "go-foks";
    tag = "v${version}";
    hash = "sha256-/+Z/afzj5y4CVU3qRymSIUzCabT2jAEBlKKoYgKlPRE=";
  };
  version = "0.1.5";
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

  vendorHash = "sha256-nTHsYMQjVaQM+g2MM++/BDVYfzIM4CaMM6eK5GQE6Cc=";

  postPatch =
    # Generate templates
    ''
      pushd ./server/web/templates
      ${templFoks}/bin/templ generate
      popd
    ''
    # Generate tailwind
    + ''
      pushd ./server/web/frontend
      mkdir -p ../static/css
      ${lib.getExe tailwindcss_4} -i ./css/input.css -o ../static/css/style.min.css --minify
      ${lib.getExe tailwindcss_4} -i ./css/input.css -o ../static/css/style.css
      ${lib.getExe uglify-js} -c < ../static/js/foks.js > ../static/js/foks.min.js
      popd
    ''
    # Copy htmx dependency from node modules
    + ''
      pushd ./server/web/static
      mkdir -p ./js
      cp ${foksNodeModules}/node_modules/htmx.org/dist/htmx.js ./js/htmx.js
      cp ${foksNodeModules}/node_modules/htmx.org/dist/htmx.min.js ./js/htmx.min.js
      popd
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

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
