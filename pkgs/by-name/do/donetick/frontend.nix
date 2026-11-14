{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "donetick-frontend";
  # According to [1], "the frontend's own v1.2.x tags aren't what
  # a backend release actually consumes.". Instead it is suggested to
  # "pick the frontend main commit that was HEAD around your backend
  # tag's build time", which is also what the CI does[2]. So we're
  # replicating that behavior inside ./update.sh
  # [1] https://github.com/donetick/donetick/discussions/787
  # [2] https://github.com/donetick/donetick/blob/06f06f70b3114bcd03fdd7662fac6740f92c3fcf/.github/workflows/go-release.yml#L30
  version = "unstable-2026-07-25";

  src = fetchFromGitHub {
    owner = "donetick";
    repo = "frontend";
    rev = "ec8eb395992ff19226bef560b01ebf2c78497177";
    hash = "sha256-yffrSB88odLkCqTdMfIi0yYldnDiXHrOACc+qvwtw+w=";
  };

  __structuredAttrs = true;

  # Upstream package-lock.json is broken. We also need to remove
  # dev-dependencies whose build scripts try to access the network,
  # so we vendor both files
  postPatch = ''
    cp ${./package.json} package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-950Pe+ToStjZb2fy+T+aIsGUIPfbPQNU23D3GdUs5+k=";

  npmBuildScript = "build";
  npmBuildFlags = [
    "--"
    "--mode"
    "selfhosted"
  ];

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    description = "Web frontend for Donetick, built as static assets to be embedded in the Go backend";
    homepage = "https://github.com/donetick/frontend";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
