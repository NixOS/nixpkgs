{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "copilot-language-server";
  version = "1.275.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-${version}.tgz";
    hash = "sha256-OVqtwz9T5vSYAZc8nof0jXn7H40i1r7SAS6jK4xeSlo=";
  };

  npmDepsHash = "sha256-PLX/mN7xu8gMh2BkkyTncP3+rJ3nBmX+pHxl0ONXbe4=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  postInstall = ''
    ln -s $out/lib/node_modules/@github/copilot-language-server/dist $out/lib/node_modules/@github/dist
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Use GitHub Copilot with any editor or IDE via the Language Server Protocol";
    homepage = "https://github.com/features/copilot";
    license = {
      deprecated = false;
      free = false;
      fullName = "GitHub Copilot Product Specific Terms";
      redistributable = false;
      shortName = "GitHub Copilot License";
      url = "https://github.com/customer-terms/github-copilot-product-specific-terms";
    };
    mainProgram = "copilot-language-server";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ arunoruto ];
  };
}
