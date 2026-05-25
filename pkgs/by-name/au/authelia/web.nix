{
  stdenv,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  fetchFromGitHub,
}:

let
  pnpm = pnpm_10;

  inherit (import ./sources.nix { inherit fetchFromGitHub; })
    pname
    version
    src
    pnpmDepsHash
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${pname}-web";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/web";

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    inherit pnpm; # This may be different than pkgs.pnpm
    fetcherVersion = 3;
    hash = pnpmDepsHash;
  };

  postPatch = ''
    NL=$'\n'
    LINE_BEFORE_HOST='allowedHosts: ["login.example.com", ...allowedHosts],'

    substituteInPlace ./vite.config.ts \
      --replace-fail 'outDir: "../internal/server/public_html"' 'outDir: "dist"' \
      --replace-fail "$LINE_BEFORE_HOST" "$LINE_BEFORE_HOST$NL"'            host: "127.0.0.1",'
  '';

  postBuild = ''
    pnpm run build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mv dist $out/share/authelia-web

    runHook postInstall
  '';
})
