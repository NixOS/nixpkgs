{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  nodejs_26,
  callPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "opengym";
  version = "1.4.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DuarteSantos8";
    repo = "openGym";
    rev = "2d70e026effc6602f513555166a97443520f0572";
    hash = "sha256-YkuPELGnAfjmC/CK7SR/c2OhyP+VdLgK/O2qmDKn/Sw=";
  };

  sourceRoot = "${finalAttrs.src.name}/api";

  npmDepsHash = "sha256-qjLSyj/CV0nSgiNLx6EzXyXEWuAmP3hwe5enfgO+pjM=";

  nativeBuildInputs = [ makeWrapper ];

  dontNpmBuild = true;

  installPhase = ''
    mkdir -p $out/lib/opengym $out/bin
    cp -r . $out/lib/opengym/

    makeWrapper ${nodejs_26}/bin/node $out/bin/opengym \
      --add-flags "$out/lib/opengym/server.js" \
      --set NODE_ENV production
  '';

  passthru = {
    frontend = callPackage ./frontend.nix {
      inherit (finalAttrs) src version;
    };
    mcp = callPackage ./mcp.nix {
      inherit (finalAttrs) src version;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Self-hosted workout tracker";
    homepage = "https://github.com/DuarteSantos8/openGym";
    mainProgram = "opengym";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ luuumine ];
    platforms = lib.platforms.linux;
  };
})
