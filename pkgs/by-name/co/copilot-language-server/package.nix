{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "copilot-language-server";
  version = "1.273.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-${version}.tgz";
    hash = "sha256-S3LhyNg8sSJPl+vnMir4AbyerORz0b1S7JyjCeoXW2E=";
  };

  npmDepsHash = "sha256-ikITGNY6a6SKOSTBU9q4sQMX51mOxMix+a1Bt+h9wGw=";

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
