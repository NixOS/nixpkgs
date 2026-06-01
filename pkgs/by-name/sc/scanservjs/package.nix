{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "scanservjs";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "sbs20";
    repo = "scanservjs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VfFahIyn2MIW4E0sMCpqdduP7F0U7t4a5c1fwpQl7Dc=";
  };

  npmDepsHash = "sha256-VB4z7PCOUzhSbSbxLj/47oppMdTvd2lT7WZKDqd+jfo=";

  postInstall = ''
    mkdir $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/scanservjs \
      --set NODE_ENV production \
      --add-flags "'$out/lib/node_modules/scanservjs/app-server/src/server.js'"
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
