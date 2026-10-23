{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "interval-tree";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "5cript";
    repo = "interval-tree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IOIp60mu1QXoizhFHsLIqTDBphPy0MwzqhkyWhxpz5g=";
  };

  # interval-tree is a header only library
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -r $src/include/ $out/

    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ header only interval tree implementation";
    maintainers = with lib.maintainers; [ aiyion ];
    homepage = "https://github.com/5cript/interval-tree";
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
  };
})
