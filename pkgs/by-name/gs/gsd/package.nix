{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs_22,
  makeWrapper,
  fd,
  ripgrep,
  gh,
}:

buildNpmPackage (finalAttrs: {
  pname = "gsd";
  version = "3.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gsd-build";
    repo = "gsd-2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IXdsW7rUE6TIaIVqLSzVDwYZE+plvRwCXfepoMj/wQQ=";
  };

  npmDepsHash = "sha256-qOrMx2yBywxjavt7g5253mcWmYhTO6bbS6eecn04Kew=";

  webNpmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-web-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/web";
    hash = "sha256-K6WndhLeST6jDgCetvUDeiJVkdPDzg6gz7pJjBqSi34=";
  };

  nodejs = nodejs_22;

  nativeBuildInputs = [ makeWrapper ];

  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  # buildNpmPackage's hooks read these as plain env vars; under
  # __structuredAttrs they are bash variables that need to be exported.
  prePatch = ''
    export npmDeps webNpmDeps
  '';

  postPatch = ''
    # The npm "files" array omits "extensions/" so workspace symlinks under
    # node_modules/@gsd-extensions/* end up dangling after `npm pack`. Include
    # the extensions sources so they ship with the package.
    substituteInPlace package.json \
      --replace-fail '"packages",' '"packages",
        "extensions",'
  '';

  preBuild = ''
    pushd web
    makeCacheWritable=1 npmDeps="$webNpmDeps" npmConfigHook
    popd
  '';

  postFixup =
    let
      binPath = lib.makeBinPath [
        fd
        ripgrep
        gh
      ];
    in
    ''
      for bin in gsd gsd-cli; do
        wrapProgram $out/bin/$bin --prefix PATH : ${binPath}
      done
    '';

  meta = {
    description = "Meta-prompting and spec-driven development system for autonomous coding agents";
    homepage = "https://github.com/gsd-build/gsd-2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "gsd";
  };
})
