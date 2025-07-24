{
  lib,
  stdenv,
  pkg-config,
  templ,
  tailwindcss_4,
  uglify-js,
  pcsclite,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
}:
let
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = "foks-proj";
    repo = "go-foks";
    tag = "v${version}";
    hash = "sha256-N4sWxYnHeqvG/qcqoqakUbxjtoh8CNPegYPYdrgP+z4=";
  };
  go-foks-frontend = callPackage ./frontend.nix { inherit version src; };
in
buildGoModule {
  pname = "go-foks";
  inherit version src;
  preBuild = ''
    # Generate the .go files from .templ files
    go tool templ generate -path server/web/templates
    # Copy out the static web assets from the frontend dependencies, they are embedded
    # using //go:embed directives in the server/web/static/js module
    cp ${go-foks-frontend}/lib/node_modules/go-foks-frontend/node_modules/htmx.org/dist/htmx.js \
       server/web/static/js/htmx.js
    cp ${go-foks-frontend}/lib/node_modules/go-foks-frontend/node_modules/htmx.org/dist/htmx.min.js \
       ./server/web/static/js/htmx.min.js
    # Compile CSS and place in module to be embedded
    tailwindcss -i server/web/frontend/css/input.css -o server/web/static/css/style.css
    tailwindcss -i server/web/frontend/css/input.css -o server/web/static/css/style.min.css --minify
    # Generate a minified version of foks.js to be embedded in the go module
    uglifyjs -c < server/web/static/js/foks.js > server/web/static/js/foks.min.js
  '';
  subPackages = [
    "client/foks"
    "server/foks-tool"
    "server/foks-server"
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pcsclite ];
  nativeBuildInputs = [
    templ
    tailwindcss_4
    uglify-js
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  vendorHash = "sha256-8/SVOWMoCfeiuH2As2cC/HLRs1WQIQ4/Ko1olXDq6bo=";
  meta = {
    homepage = "https://github.com/foks-proj/go-foks";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ngp ];
    description = "Go implementation of FOKS server and client";
    changelog = "https://github.com/foks-proj/go-foks/releases/tag/v${version}";
    platforms = lib.platforms.all;
    mainProgram = "foks";
  };
}
