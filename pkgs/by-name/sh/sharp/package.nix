{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "sharp";
  version = "0.34.5";

  src = fetchFromGitHub {
    owner = "lovell";
    repo = "sharp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N9gdR06Z/A4+FcOPAaMoWDD04vpf56j3jUHnS8sdbBg=";
  };

  npmDepsHash = "sha256-wjNxbz6SKRKznXqHgVhIUIQsiK4757rf+27mnZ77JQQ=";

  postPatch = ''
    # Repo doesn't have a package-lock.json
    ln -s ${./package-lock.json} package-lock.json
  '';

  doCheck = true;
  checkPhase = ''
    npm run test-unit
  '';

  meta = {
    description = "Sharp is a library to efficiently resize, convert, and manipulate images in various formats";
    homepage = "https://sharp.pixelplumbing.com/";
    changelog = "https://github.com/lovell/sharp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mana-byte ];
  };
})
