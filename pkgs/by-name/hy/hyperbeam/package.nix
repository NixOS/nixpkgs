{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "hyperbeam";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hyperbeam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SSHSQIVfHYFa1YkV3eeDkXSQV8KERADlmhOmxIiY+ko=";
  };

  npmDepsHash = "sha256-EjzdBqA1KNZbhkRkyMwC/YSgbkbs5BRC6ummQkQHyEs=";

  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "1-1 End-to-End Encrypted Internet Pipe Powered by Hyperswarm";
    homepage = "https://github.com/holepunchto/hyperbeam";
    mainProgram = "hyperbeam";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ davhau ];
  };
})
