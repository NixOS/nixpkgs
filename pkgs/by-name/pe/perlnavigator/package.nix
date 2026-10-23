{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

let
  version = "0.8.20";
  src = fetchFromGitHub {
    owner = "bscan";
    repo = "PerlNavigator";
    rev = "v${version}";
    hash = "sha256-iqn5yP/SKyKr+b+Kz+z4TbZ1giEEmrerVsHSaJwKTjM=";
  };
  browser-ext = buildNpmPackage {
    pname = "perlnavigator-web-server";
    inherit version src;
    sourceRoot = "${src.name}/browser-ext";
    npmDepsHash = "sha256-mk2O/LdTqDvv9oABLyL+ChkZHahjchthYB+hAe4heeI=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  client = buildNpmPackage {
    pname = "perlnavigator-client";
    inherit version src;
    sourceRoot = "${src.name}/client";
    npmDepsHash = "sha256-CM0l+D1VNkXBrZQHQGDiB/vAxMvpbHYoYlIugoLxSfA=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  server = buildNpmPackage {
    pname = "perlnavigator-server";
    inherit version src;
    sourceRoot = "${src.name}/server";
    npmDepsHash = "sha256-K7Dpalxxwz6HgaPvuxAKJhUMHljYbnFGCktBTiBHT2E=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
in
buildNpmPackage rec {
  pname = "perlnavigator";
  inherit version src;

  npmDepsHash = "sha256-MkkuasIZ2QGX0keD2B3xpQ3jRCfyTL1hbVSfTn0seiQ=";

  postPatch = ''
    sed -i /postinstall/d package.json

    rm -r browser-ext client server
    cp -r ${browser-ext} browser-ext
    cp -r ${client} client
    cp -r ${server} server
    chmod +w browser-ext client server
  '';

  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;
  };

  npmBuildScript = "package";

  postInstall = ''
    cp -r ${browser-ext}/node_modules "$out/lib/node_modules/perlnavigator/browser-ext"
    cp -r ${client}/node_modules "$out/lib/node_modules/perlnavigator/client"
    cp -r ${server}/node_modules "$out/lib/node_modules/perlnavigator/server"

    # only needed to build the server, and typescript alone is 65 MiB
    chmod -R u+w "$out"/lib/node_modules/perlnavigator/server/node_modules
    rm -r "$out"/lib/node_modules/perlnavigator/server/node_modules/{typescript,@types,undici-types,.bin}
  '';

  meta = {
    changelog = "https://github.com/bscan/PerlNavigator/blob/${src.rev}/CHANGELOG.md";
    description = "Perl Language Server that includes syntax checking, perl critic, and code navigation";
    homepage = "https://github.com/bscan/PerlNavigator/tree/main/server";
    license = lib.licenses.mit;
    mainProgram = "perlnavigator";
    maintainers = [ ];
  };
}
